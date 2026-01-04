import pandas as pd
import numpy as np
import phonenumbers as pn

#Function for data cleaning
def clean_data(data: pd.DataFrame):

    data_clean = data.copy()

    data_clean.drop_duplicates(inplace=True)

    for col in data_clean.columns:
        missing_data_count = data_clean[col].isnull().sum()
        if missing_data_count > 0:
            if data_clean[col].dtype == "int64" or data_clean[col].dtype == "float64":
                value = data_clean[col].median()
                data_clean[col] = data_clean[col].fillna(value)
            else:
                data_clean[col] = data_clean[col].fillna("Unknown")

        if "date" in col.lower():
            converted = pd.to_datetime(
                data_clean[col], errors="coerce", format="mixed")
            data_clean[col] = converted.dt.strftime("%Y-%m-%d")
    return data_clean

# loading the data
if __name__ == "__main__":

    customers = pd.read_csv("data/customers_raw.csv")
    products = pd.read_csv("data/products_raw.csv")
    sales = pd.read_csv("data/sales_raw.csv")

    print("Customers:", customers.shape[0], "rows")
    print("Products:", products.shape[0], "rows")
    print("Sales:", sales.shape[0], "rows")

 # clean customers data
customers_clean = clean_data(customers)
customers_clean['city'] = customers_clean["city"].str.capitalize()
print(customers_clean)


# clean product data
products_clean = clean_data(products)
products_clean['category'] = products_clean["category"].str.capitalize()
print(products_clean)