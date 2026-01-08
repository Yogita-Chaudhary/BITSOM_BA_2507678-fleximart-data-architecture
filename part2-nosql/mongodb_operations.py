
import json
from pymongo import MongoClient
import datetime
import pandas as pd

#connecting with MongoDB
MongoDB_url= 'mongodb://localhost:27017/'
database_name = 'fleximart'
collection_name = 'products'

client = MongoClient(MongoDB_url)
database = client[database_name]
collection = database[collection_name]

print('Connected to MongoDB')


with open(file='products_catalog.json', mode='r', encoding='utf-8') as f:
    data = json.load(f)

#Operation 1 - LOAD THE DATA
# Import the provided JSON file into collection 'products'

# collection.insert_many(data)
print(f'Total documents added to {database_name}.{collection_name}: {collection.count_documents({})}')

#Operation 2 - Basic Query
#  Find all products in "Electronics" category with price less than 50000
#  Return only: name, price, stock

Op_2 = database["products"].find({"category" : "Electronics", 
                               "price": {"$lt": 50000}}, 
                              {"_id": 0, "name" : 1, 
                               "price": 1, "stock": 1}
                               )
print(pd.DataFrame(Op_2))

# Operation 3 - Review Analysis
# Find all products that have average rating >= 4.0
# Use aggregation to calculate average from reviews array

pipeline = [
    {"$addFields": {"avg_rating": {"$avg": "$reviews.rating"}}},
    {"$match": {"avg_rating": {"$gte": 4.0}}},
    {"$project": {"_id": 0, "product_id": 1, "name": 1, "category": 1, "avg_rating": 1}}
]
for doc in collection.aggregate(pipeline):
  print(pd.DataFrame(list(doc)))


# Operation 4 - Update Operation (2 marks)

# Add a new review to product "ELEC001"
# Review: {user: "U999", rating: 4, comment: "Good value", date: ISODate()}

new_review = database["products"].update_one({"product_id": "ELEC001"},
    {"$push": {"user": "U999", "rating": 4, "comment": "Good value", "date": datetime.datetime.now()}})

print({"matched": new_review.matched_count, "modified": new_review.modified_count})
updated_review = collection.find_one({"product_id": "ELEC001"},
    {"_id": 0, "product_id": 1, "name": 1, "reviews": 1})
print(updated_review)


# Operation 5 - Complex Aggregation
# Calculate average price by category
# Return: category, avg_price, product_count
# Sort by avg_price descending

pipeline5 = [
    {
        "$group": {
            "_id": "$category",
            "avg_price": {"$avg": "$price"},
            "product_count": {"$sum": 1},
        }
    },
    {
        "$project": {
            "_id": 0,
            "category": "$_id",
            "avg_price": {"$round": ["$avg_price", 2]},
            "product_count": 1,
        }
    },
    {"$sort": {"avg_price": -1}},
]

print(pd.DataFrame(list(collection.aggregate(pipeline5))))