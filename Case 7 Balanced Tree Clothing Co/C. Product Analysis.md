# Case Study #7 - Balanced Tree Clothing Co.

## Solution - C. Product Analysis


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

***

### 1. What are the top 3 products by total revenue before discount?

- To solve this problem, we will calculate the total revenue by multiplying the total quantity x the total price from the saless cte.
- Then we will pull the product information from the product details table through an inner join
- CONCAT to add the dollar sign $$$

````sql
SELECT s.product_id, s.Product, CONCAT('$', s.[Total Revenue]) AS [Total Revenue]
FROM
(
SELECT TOP 3  pd.product_id, pd.product_name AS [Product], SUM(sls.qty * sls.price) AS [Total Revenue]
FROM saless AS sls
INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
GROUP BY pd.product_id, pd.product_name
ORDER BY [Total Revenue] DESC
)s

````

**Answer:**


![Screen Shot 2023-07-09 at 9 36 27 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/85c4930b-0beb-4b69-940e-54dcb4467b1c)



- Here we can see that Blue Polo Shirt for Mens accumulated the highest total revenue of $217683


***



### 2. What is the total quantity, revenue and discount for each segment?

````sql

````


**Answer:**

***


### 3. What is the top selling product for each segment?

````sql

````


**Answer:**

***


### 4. What is the total quantity, revenue and discount for each category?

````sql

````


**Answer:**

***


### 5. What is the top selling product for each category?

````sql

````


**Answer:**

***


### 6. What is the percentage split of revenue by product for each segment?

````sql

````


**Answer:**

***


### 7. What is the percentage split of revenue by segment for each category?

````sql

````


**Answer:**

***


### 8. What is the percentage split of total revenue by category?

````sql

````


**Answer:**

***


### 9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)

````sql

````


**Answer:**

***


### 10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?

````sql

````


**Answer:**

***


