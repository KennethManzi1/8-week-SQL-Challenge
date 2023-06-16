# Case Study #4 - Data Bank

## Solution - A.  Customer Nodes Exploration

## Because the dataset was way over 1000 rows, I had to split the customer nodes data into 5 tables and UNION ALL them in a CTE to create the customer nodes table



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

