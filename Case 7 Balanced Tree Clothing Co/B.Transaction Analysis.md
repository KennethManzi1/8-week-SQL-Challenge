# Case Study #7 - Balanced Tree Clothing Co

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

## Solution - B. Transaction Analysis

### 1. How many unique transactions were there?

- We will use DISTINCT to get the unique transactions then count them to get the number of unique transactions

````SQL
SELECT COUNT(DISTINCT txn_id) AS [Number of Unique Transactions]
FROM saless

````

**Answer:**

![Screen Shot 2023-07-08 at 10 46 08 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/2e85acf4-ee4e-4ff3-986b-1a399701c96f)

- There are 2500 Transactions

***

### 2. What is the average unique products purchased in each transaction?

- We will create a Subquery to get the distinct transactions and the total number of products that were purchased(quantity column) per transaction.
- After that we will create an outer query to get the average amount of the products that were purchased.


````SQL
SELECT ROUND(AVG(a.[Total quantity of products]), 1) AS [Average Unique Products]
FROM
(
SELECT DISTINCT txn_id, SUM(qty) AS [Total quantity of products]
FROM saless
Group By txn_id
)a

````
**Answer:**

![Screen Shot 2023-07-09 at 4 10 46 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/a162a2f7-8e55-4304-8005-acfd228466b7)

- Thare are 18 unique products purchased in each transaction.

***

### 3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?

- We will first create a subquery to find our total revenue per transaction.
- Using that query we will calculate the  Percentiles using the PERCENTILE_CONT() WITHIN GROUP () function


````SQL

SELECT p.txn_id AS [Transaction], PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY p.[Revenue]) OVER() AS [25th Percentile],
PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY p.[Revenue]) OVER() AS [50th Percentile],
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY p.[Revenue]) OVER() AS [75th Percentile]
FROM 
(
SELECT txn_id, SUM(qty * price) AS [Revenue]
FROM saless
GROUP BY txn_id
)p
````

**Answer:**
![Screen Shot 2023-07-09 at 4 14 29 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/d70d38f4-1ec8-4b16-ba41-84833f2427f4)

***

### 4. What is the average discount value per transaction?

- We will first create a subquery to find our total discount per transaction.
- Then we will find the Average Discount on the outer query.


````SQL
SELECT  ROUND(AVG(av.[Revenue With Discount]), 1 ) AS [Average Discount]
FROM 
(
SELECT  SUM(qty * price * CAST(discount AS FLOAT)/100) AS [Revenue with Discount]
FROM saless AS s
GROUP BY txn_id
)av
````
**Answer:**
![Screen Shot 2023-07-09 at 4 17 06 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/70d84e91-15bf-4989-a792-05442ca7c65e)

- The average discount value per transaction is 62.5

***

### 5. What is the percentage split of all transactions for members vs non-members?


````SQL
SELECT member, ROUND(100 * CAST(COUNT(member) AS FLOAT)/(SELECT COUNT(member) FROM saless),2) AS [Member Percentage]
FROM saless
GROUP BY member
````
![Screen Shot 2023-07-09 at 4 19 16 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/9241348d-4e35-4dd9-95c7-c9949f3172db)


***


### 6. What is the average revenue for member transactions and non-member transactions?
- WE will create a subquery to get the total revenue first per member and transaction.
- Then in the outer query we will find the average revenue


````SQL

SELECT aa.member, ROUND(AVG(aa.[Total Revenue]), 1) AS [Average Revenue]
FROM 
(
SELECT member, txn_id, SUM(qty * price) AS [Total Revenue]
FROM saless
GROUP by member, txn_id
)aa
GROUP BY aa.member
````
![Screen Shot 2023-07-09 at 4 21 21 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/61229593-e3dc-4214-b46a-a8375b693dbe)


***

