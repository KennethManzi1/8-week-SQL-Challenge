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
