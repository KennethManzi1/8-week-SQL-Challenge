# Case Study #7 - Balanced Tree Clothing Co.

## Solution - A. High Level Sales Analysis

- Because the Sales data is over 150000 rows and Azure Data studio so far only lets me insert 1000 rows of data per table, I decided to create 15 CTEs to insert data and UNION them all in a CTE called saless

````SQL

  WITH Saless AS
  (
    SELECT *
    FROM sales
    
    UNION ALL
    
    SELECT *
    FROM sales1
    
    UNION ALL
    
    SELECT *
    FROM sales2 
    
    UNION ALL
    
    SELECT *
    FROM sales3

    UNION ALL
    
    SELECT *
    FROM sales4 

    UNION ALL
    
    SELECT *
    FROM sales5

    UNION ALL
    
    SELECT *
    FROM sales6

    UNION ALL
    
    SELECT *
    FROM sales7

    UNION ALL
    
    SELECT *
    FROM sales8

    UNION ALL

    SELECT *
    FROM sales88

    UNION ALL
    
    SELECT *
    FROM sales9

    UNION ALL
    
    SELECT *
    FROM sales10

    UNION ALL
    
    SELECT *
    FROM sales11

    UNION ALL
    
    SELECT *
    FROM sales12

    UNION ALL
    
    SELECT *
    FROM sales13

    UNION ALL
    
    SELECT *
    FROM sales14
  )
````





### 1. What was the total quantity sold for all products?

- We will find the total quantity of the products using the SUM function.
- We will get the exact matching products that much with their quantities using the Inner join from the product_details table

````SQL
SELECT sum(qty) AS [Total Quantity of products sold]
FROM saless AS s
INNER JOIN product_details as p ON s.prod_id = p.product_id
GROUP BY p.product_name


````


**Answer:**
![Screen Shot 2023-07-08 at 3 30 05 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/8c757099-9bf6-40b4-bffb-b53bff422351)

Total is 45216

***


### 2. What is the total generated revenue for all products before discounts?

- The formula to calculate revenue is Quantity x Price and to get the total revenue before discountswe will use the Sum function as well.
- We will get the exact matching products that much with their quantities using the Inner join from the product_details table

````SQL
SELECT SUM(R.Revenue) AS [Total Revenue Before Discounts], p.product_name
FROM
(
SELECT prod_id, (qty * price) AS [Revenue]
FROM saless
)R
INNER JOIN product_details as p ON R.prod_id = p.product_id
GROUP BY p.product_name
`````



**Answer:**

![Screen Shot 2023-07-08 at 3 33 50 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/f69d9f86-2a80-4c7b-906f-e14a6ddd2539)

- Total Revenue Before Discounts is 1,289,453

***

### 3. What was the total discount amount for all products?

- Quantity times price times discount to get the discounted revenue then we will use the SUM function and round the total discount to two decimal places.
- We will get the exact matching products that much with their quantities using the Inner join from the product_details table.

````SQL
SELECT p.product_name, ROUND(SUM(D.[Revenue with Discount]), 2) AS [Total Discount]
FROM
(
SELECT prod_id, (qty * price * CAST(discount AS FLOAT)/100) AS [Revenue with Discount]
FROM saless AS s
)D
INNER JOIN product_details as p ON D.prod_id = p.product_id
GROUP BY p.product_name

````


**Answer:**

![Screen Shot 2023-07-08 at 3 38 26 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/e53b5b04-1bb7-491c-9794-afb3a7bdda42)

- The total discount is 156229.14

Click [here] for solution to B. Transaction Analysis


***
