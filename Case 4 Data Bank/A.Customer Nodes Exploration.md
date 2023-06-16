# Case Study #4 - Data Bank

## Solution - A.  Customer Nodes Exploration

## Because the dataset was way over 1000 rows, I had to split the customer nodes data into 6 tables and UNION ALL them in a CTE to create the customer nodes table



### 1.How many unique nodes are there on the Data Bank system?

````sql
WITH customernodess AS(
    SELECT *
    FROM dbo.customer_nodes

    UNION ALL

    SELECT *
    FROM dbo.customer_nodes2

    UNION ALL

    SELECT * 
    FROM dbo.customer_nodes3

    UNION ALL
    
    SELECT *
    FROM dbo.customer_nodes4
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes5
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes6

)

SELECT COUNT(DISTINCT node_id) AS [Number of Unique Nodes]
FROM customernodess

````
**Answer:**

There are 5 unique nodes on the data bank system

### 2. What is the number of nodes per region?

````sql
WITH customernodess AS(
    SELECT *
    FROM dbo.customer_nodes

    UNION ALL

    SELECT *
    FROM dbo.customer_nodes2

    UNION ALL

    SELECT * 
    FROM dbo.customer_nodes3

    UNION ALL
    
    SELECT *
    FROM dbo.customer_nodes4
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes5
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes6

)

SELECT cus.region_id, reg.region_name, COUNT(cus.node_id) AS [Number of Nodes]
FROM dbo.regions AS reg
INNER JOIN customernodess AS cus ON reg.region_id = cus.region_id
GROUP BY cus.region_id, reg.region_name
````
**Answer:**
![Screen Shot 2023-06-15 at 9 45 56 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/a95f2a28-a42a-4426-a5a2-cfa19c5b7112)

Australia had the highest number of nodes and Europe had the lowest number of nodes.

### 3. How many customers are allocated to each region?
````sql

WITH customernodess AS(
    SELECT *
    FROM dbo.customer_nodes

    UNION ALL

    SELECT *
    FROM dbo.customer_nodes2

    UNION ALL

    SELECT * 
    FROM dbo.customer_nodes3

    UNION ALL
    
    SELECT *
    FROM dbo.customer_nodes4
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes5
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes6

)


SELECT cus.region_id, reg.region_name, COUNT(DISTINCT cus.customer_id) AS [Number of Customers Allocated]
FROM dbo.regions AS reg
INNER JOIN customernodess AS cus ON reg.region_id = cus.region_id
GROUP BY cus.region_id, reg.region_name
````

**Answer:**
![Screen Shot 2023-06-15 at 10 11 46 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/95aa4d02-8b59-41c9-8deb-85d4250b92ea)

Australia has the most number of custoemrs allocated at 110, Europe has the least number of customers allocated at 88.


### 4. How many days on average are customers reallocated to a different node?

````sql

WITH customernodess AS(
    SELECT *
    FROM dbo.customer_nodes

    UNION ALL

    SELECT *
    FROM dbo.customer_nodes2

    UNION ALL

    SELECT * 
    FROM dbo.customer_nodes3

    UNION ALL
    
    SELECT *
    FROM dbo.customer_nodes4
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes5
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes6

)
--Find the Average difference between the end date and the start date in Days and filter out dates that are not formatted

SELECT AVG(DATEDIFF(DAY, start_date, end_date)) AS [Average days a customer was allocated]
FROM customernodess
WHERE start_date != '9999-12-31' and end_date != '9999-12-31'
````
**Answer:**

It takes on average 14 days for customers to be allocated to a region.


### 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

````sql

WITH customernodess AS(
    SELECT *
    FROM dbo.customer_nodes

    UNION ALL

    SELECT *
    FROM dbo.customer_nodes2

    UNION ALL

    SELECT * 
    FROM dbo.customer_nodes3

    UNION ALL
    
    SELECT *
    FROM dbo.customer_nodes4
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes5
    UNION ALL
    SELECT *
    FROM dbo.customer_nodes6

),
--Date Diff CTE to calculate the difference between the start and end date allocation days.
Date_diff AS
(
SELECT cus.customer_id, DATEDIFF(DAY, cus.start_date, cus.end_date) AS [Days a customer was allocated], rg.region_id, rg.region_name
FROM customernodess cus
INNER JOIN regions AS rg ON cus.region_id = rg.region_id
WHERE start_date != '9999-12-31' and end_date != '9999-12-31'

)
-- WE will use PERCENTILE_CONT and WITHIN GROUP to find the median, 80th,and 95th percentile
SELECT DISTINCT region_id, region_name, PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY [Days a customer was allocated]) OVER(PARTITION BY region_name) AS median,
	   PERCENTILE_CONT(0.8) WITHIN GROUP(ORDER BY [Days a customer was allocated]) OVER(PARTITION BY region_name) AS percentile_80,
	   PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY [Days a customer was allocated]) OVER(PARTITION BY region_name) AS percentile_95
FROM Date_diff
ORDER BY region_id
````
**Answer:**

![Screen Shot 2023-06-15 at 10 22 15 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/db1f556d-b489-41d7-b2b4-0fb7564510d8)

The output shows that all the regions have same median and 95th percentile for the same reallocation days metric with Africa and Europe having 24 days as the 80th percentile and America, Asia and Australia having 23 days as the 80th percentile reallocation metric.


***Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%204%20Data%20Bank/B.%20Customer%20Transactions.md)
for solution for B. Customer Transactions
