# Case Study #7 - Balanced Tree Clothing Co.

## Solution - C. Product Analysis

### 1. What are the top 3 products by total revenue before discount?

- To solve this problem, we will calculate the total revenue by multiplying the total quantity x the total price from the saless cte.
- Then we will pull the product information from the product details table through an inner join
- CONCAT to add the dollar sign $$$

````sql
SELECT s.product_id, s.Product, CONCAT('$', s.[Total Revenue])
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

![Screen Shot 2023-07-09 at 9 20 47 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/2e1a4da3-86d6-45e3-b428-2f382ca8a97a)



- Here we can see that Blue Polo Shirt for Mens accumulated the highest total revenue of $217,683


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


