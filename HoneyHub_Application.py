#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 28 14:32:31 2024
@author: zackporter
"""

import mysql.connector
import matplotlib.pyplot as plt
import numpy as np

# Establish a database connection
try:
    cnx = mysql.connector.connect(
        user='root',
        password='12345',
        host='127.0.0.1',
        database='HoneyHub'
    )
    print("Successfully connected to the database.")
except mysql.connector.Error as err:
    print(f"Database connection failed: {err}")
    exit(1)

cursor = cnx.cursor()

# Query 1: Gender distribution of users
query1 = "SELECT gender, COUNT(*) AS user_count FROM USERS GROUP BY gender;"
cursor.execute(query1)
genders = []
user_counts = []
for (gender, user_count) in cursor:
    genders.append(gender)
    user_counts.append(user_count)

# Plotting the results of Query 1
plt.figure(figsize=(8, 8))
plt.pie(user_counts, labels=genders, autopct='%1.1f%%', startangle=140)
plt.title('Count of Users by Gender')
plt.axis('equal')
plt.show()

# Query 2: Top ten most popular products based on orders
query2 = """
SELECT p.product_name, COUNT(*) AS order_count
FROM PRODUCTS p
JOIN ORDER_ITEMS oi ON p.product_ID = oi.product_ID
GROUP BY p.product_name
ORDER BY order_count DESC
LIMIT 10;
"""
cursor.execute(query2)
product_names = []
order_counts = []
for (product_name, order_count) in cursor:
    product_names.append(product_name)
    order_counts.append(order_count)

# Plotting the results of Query 2
plt.figure(figsize=(10, 6))
plt.bar(np.arange(len(product_names)), order_counts, color='skyblue')
plt.xlabel('Product Name')
plt.ylabel('Order Count')
plt.title('Top Ten Most Popular Products')
plt.xticks(np.arange(len(product_names)), product_names, rotation=45, ha='right')
plt.tight_layout()
plt.show()

# Query 3: Sales trend comparison year over year
query3 = """
SELECT YEAR(date_time) AS Year, SUM(total_amount) AS TotalSales
FROM PAYMENTS
GROUP BY Year
ORDER BY Year;
"""
cursor.execute(query3)
years = []
sales = []
for (year, total_sales) in cursor:
    years.append(year)
    sales.append(float(total_sales))

# Plotting the results of Query 3 
plt.figure(figsize=(10, 6))
plt.plot(years, sales, marker='o', linestyle='-', color='b')
plt.xlabel('Year')
plt.ylabel('Total Sales ($)')
plt.title('Yearly Sales Trend')
plt.xticks(years, rotation=45)  
plt.tight_layout()  
plt.grid(True)
plt.show()


# Query 4: Top 10 total sales per social media type
query4 = """
SELECT s.type, SUM(p.total_amount) AS TotalSales
FROM SOCIAL_MEDIAS s
JOIN USERS u ON s.user_ID = u.user_ID
JOIN CUSTOMERS c ON u.user_ID = c.customer_ID
JOIN ORDERS o ON c.customer_ID = o.customer_ID
JOIN PAYMENTS p ON o.order_ID = p.payment_ID
GROUP BY s.type
ORDER BY TotalSales DESC
LIMIT 10;
"""
cursor.execute(query4)
social_media_types = []
total_sales = []
for (type, sales) in cursor:
    social_media_types.append(type)
    total_sales.append(float(sales))

# Plotting the results of Query 4
plt.figure(figsize=(10, 6))
plt.bar(social_media_types, total_sales, color='orange')
plt.xlabel('Social Media Type')
plt.ylabel('Total Sales ($)')
plt.title('Top 10 Social Media Types by Total Sales')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.show()

# Query 5: Inventory levels across stores with the top 10 highest inventory levels
query5 = """
SELECT s.store_name, SUM(ii.quantity) AS TotalInventory
FROM INVENTORY_ITEMS ii
JOIN STORES s ON ii.store_ID = s.store_ID
GROUP BY s.store_name
ORDER BY TotalInventory DESC
LIMIT 10;
"""
cursor.execute(query5)
stores = []
inventory_levels = []
for (store_name, total_inventory) in cursor:
    stores.append(store_name)
    inventory_levels.append(total_inventory)

# Plotting the results of Query 5
plt.figure(figsize=(10, 6))
plt.bar(stores, inventory_levels, color='green')
plt.xlabel('Store Name')
plt.ylabel('Total Inventory Level')
plt.title('Top 10 Stores by Inventory Level')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.show()

# Close the cursor and the connection
cursor.close()
cnx.close()
print("Database connection closed.")
