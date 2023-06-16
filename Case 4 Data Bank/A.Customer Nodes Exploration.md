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
