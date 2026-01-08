import pandas as pd
import numpy as np
import phonenumbers as pn
import mysql.connector
from dotenv import load_dotenv
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Function for data cleaning

data_quality_report = []

def clean_data(data: pd.DataFrame) -> pd.DataFrame:
    """
    Cleans raw input data by handling missing values, standardizing date formats,
    and removing duplicate rows.
    """
    for col in data.columns:
        missing_data_count = data[col].isnull().sum()
        if missing_data_count > 0:
            missing_columns_data = ''.join(f"{col}: {missing_data_count}")
            if data[col].dtype == 'int64' or data[col].dtype == 'float64':
                value = data[col].median()
                data[col] = data[col].fillna(value)
            else:
                data[col] = data[col].fillna('Unknown')

        if 'date' in col.lower():
            converted = pd.to_datetime(
                data[col], errors='coerce', format='mixed')
            data[col] = converted.dt.strftime("%Y-%m-%d")

    data_duplicate = data.drop_duplicates(keep='first').copy()

    data_quality_report.append({
        'Records processed': len(data),
        'Duplicates removed': int(data.duplicated().sum()),
        'Missing values handled': missing_columns_data,
        'Records loaded successfully': len(data_duplicate)
    })

    return data_duplicate


def standardize_customer_data(customers_data):
    """
    Standardizes customer data by formatting city names, normalizing phone numbers,
    and converting customer IDs to numeric format.
    """
    customers_data = customers_data.copy()
    customers_data['city'] = customers_data['city'].str.title()
    customers_data['phone'] = [
        pn.format_number(
            pn.parse(x, region='IN'),
            pn.PhoneNumberFormat.E164
        ).replace('+91', '+91-')
        for x in customers_data['phone']
    ]
    customers_data['customer_id'] = customers_data['customer_id'].astype(str).replace(r'\D+', '', regex=True).astype('Int64')
    return customers_data


def standardize_products_data(products_data):
    """
    Standardizes product data by cleaning category names, product names,
    and converting product IDs to numeric format.
    """
    products_data['category'] = products_data['category'].str.title()
    products_data['product_name'] = products_data['product_name'].astype(str).str.strip().str.replace(r'\s+', ' ', regex=True)
    products_data['product_id'] = products_data['product_id'].astype(str).replace(r'\D+', '', regex=True).astype('Int64')
    return products_data


def standardize_sales_data(sales_data):
    """
    Cleans and prepares sales data for order and order item generation.
    """
    sales_data = sales_data.copy()
    sales_data[['customer_id', 'product_id']] = sales_data[['customer_id', 'product_id']].replace('Unknown', np.nan)
    sales_data = sales_data.dropna(subset=['customer_id', 'product_id']).reset_index(drop=True)
    sales_data[['transaction_id', 'customer_id', 'product_id']] = sales_data[
        ['transaction_id', 'customer_id', 'product_id']
    ].astype(str).replace(r'\D+', '', regex=True).astype('Int64')
    sales_data = sales_data.rename(columns={'transaction_id': 'order_id', 'transaction_date': 'order_date'})
    sales_data['subtotal'] = sales_data['quantity'] * sales_data['unit_price']
    return sales_data


def build_order_data(data):
    """
    Builds order-level data by aggregating order items.
    """
    return (
        data
        .groupby(
            ["order_id", "customer_id", "order_date", "status"],
            as_index=False
        )
        .agg(total_amount=("subtotal", "sum"))
    )


def get_db_connection():
    """
    Creates and returns a MySQL database connection using environment variables.
    """
    load_dotenv()
    return mysql.connector.connect(
        host=os.getenv('HOST_URL'),
        user=os.getenv('USER_NAME'),
        password=os.getenv('PASSWORD'),
        database=os.getenv('DATABASE_NAME')
    )


def save_data(data, table_name):
    """
    Inserts DataFrame records into a specified MySQL table.
    """
    connection = get_db_connection()
    cursor = connection.cursor()
    cols_names = ",".join(data.columns)
    placeholder = ",".join(["%s"] * len(data.columns))
    sql = f"insert into {os.getenv('DATABASE_NAME')}.{table_name} ({cols_names}) values ({placeholder})"
    cursor.executemany(sql, data.values.tolist())
    connection.commit()
    cursor.close()
    connection.close()


# loading the data
if __name__ == '__main__':
    print(BASE_DIR)
    customers = pd.read_csv(f'{BASE_DIR}/data/customers_raw.csv')
    products = pd.read_csv(f'{BASE_DIR}/data/products_raw.csv')
    sales = pd.read_csv(f'{BASE_DIR}/data/sales_raw.csv')

    print(f'Customers: {len(customers)} rows')
    print(f'Products: {len(products)} rows')
    print(f'Sales: {len(sales)} rows')

    # clean customers data
    customers_clean = clean_data(customers)
    customers_clean = standardize_customer_data(customers_clean)

    # save customer data to database
    save_data(customers_clean, 'customers')

    # clean product data
    products_clean = clean_data(products)
    products_clean = standardize_products_data(products_clean)

    # save products to database
    save_data(products_clean, 'products')

    # clean sales data
    sales_clean = clean_data(sales)
    sales_clean = standardize_sales_data(sales_clean)

    # get order data from sales data
    order_data = build_order_data(sales_clean)

    # save order data to database
    save_data(order_data, 'orders')

    # save order_items data to database
    order_items_data = sales_clean[
        ["order_id", "product_id", "quantity", "unit_price", "subtotal"]
    ]
    # save_data(order_items_data, 'order_items')

    report = pd.DataFrame(data_quality_report)
    report.to_csv(f'{BASE_DIR}/Results/data_quality_report.csv', index=False)

