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

