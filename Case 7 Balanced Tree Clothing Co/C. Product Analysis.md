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
  
- Then we will pull the product information from the product details table through an INNER JOIN .
  
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

- To solve this problem, we will calculate the total revenue by multiplying the total quantity x the total price from the saless cte and we will also find the total quantity from the saless cte.
  
- We will get the total discount as well and we will pull the segments from the product details table through an INNER JOIN.

- CONCAT to add the dollar sign $$$


````sql

SELECT s.segment_id, s.Segment, s.[Total Quantity], CONCAT('$', s.[Total Revenue before Discount]) AS [Total Revenue Before Discount], 
CONCAT('$', s.[Total Discount]) AS [Total Discount]
FROM 
(
SELECT pd.segment_id, pd.segment_name AS [Segment], SUM(qty) AS [Total Quantity], SUM(sls.qty * sls.price) AS [Total Revenue before Discount],
ROUND(SUM(sls.qty * sls.price * (CAST(sls.discount AS FLOAT))/100), 1) AS [Total Discount]
FROM saless AS sls
INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
GROUP BY pd.segment_id, pd.segment_name
)s
ORDER BY s.segment_id

````


**Answer:**

![Screen Shot 2023-07-09 at 9 50 02 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/c74e0f75-0f7c-4da0-8373-ffd177155426)

- Here we can see that the Shirt Segment has the highest total revenue of $406143 and the highest total discount of $49594.3

***


### 3. What is the top selling product for each segment?
- To get the top selling product for each segment, you can create a rank for the top selling product for each segment using the RANK() Window function.
  
- So we will pull in the segment and product information,then create a ranking for the top selling product in a subquery.
  
- In the outer query we filter the top selling product and its segment by the top rank


````sql
SELECT r.segment_id, r.Segment, r.product_id, r.Product, r.[Total Quantity], r.[Ranked Products]
FROM 
(
SELECT pd.segment_id, pd.segment_name AS [Segment], pd.product_id, pd.product_name AS [Product], 
SUM(sls.qty) AS [Total Quantity],RANK() OVER(PARTITION BY pd.segment_id ORDER BY SUM(sls.qty)) AS [Ranked Products]
FROM saless AS sls
INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
GROUP BY pd.segment_id, pd.segment_name, pd.product_id, pd.product_name
)r
WHERE r.[Ranked Products] = 1


````


**Answer:**

![Screen Shot 2023-07-10 at 5 06 51 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/6790ca14-45d5-4557-806d-f225513780ea)

- We can see that the women's top two segments have a higher quantity than the men's top two segments and for women they prefer cream relaxed jeans and a khaki suit jacket as those two are the top selling jeans and jackets for women.
  
- For the mens we can see that they mostly prefer a Teal Button Up shirt and  white striped socks as those two are the top selling shirts and socks for men


***

- We will solve this problem by pulling the category names, calculating the total quantity, total revenue, and the total discount. Luckily we have already calculated the total quantity, total revenue, and total discount before so this shouldn't be too difficult.
  
- CONCAT to add the Dollar sign $$.

### 4. What is the total quantity, revenue and discount for each category?

````sql
SELECT s.category_id, s.Category, s.[Total Quantity], CONCAT('$', s.[Total Revenue before Discount]) AS [Total Revenue Before Discount], CONCAT('$', s.[Total Discount]) AS [Total Discount]
FROM 
(
SELECT pd.category_id, pd.category_name AS [Category], SUM(sls.qty) AS [Total Quantity], SUM(sls.qty * sls.price) AS [Total Revenue before Discount],
ROUND(SUM(sls.qty * sls.price * (CAST(sls.discount AS FLOAT))/100), 1) AS [Total Discount]
FROM saless AS sls
INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
GROUP BY pd.category_id, pd.category_name
--ORDER BY pd.category_id, pd.category_name
)s
ORDER BY s.category_id, S.Category

````


**Answer:**

![Screen Shot 2023-07-10 at 5 36 21 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/a20fd284-0526-430c-bad0-917e0e0961e1)

- Here we can see that the Men's category had a higher Total Revenue and a higher total discount than the women's category despite the women's category having a higher quantity of products than the men's category


***


### 5. What is the top selling product for each category?

- We will do the same Ranking as we did for number 3 except this time we are ranking the top selling products per category rather than the segment


````sql
SELECT r.category_id, r.Category, r.product_id, r.Product, r.[Total Quantity], r.[Ranked Products]
FROM 
(
SELECT pd.category_id, pd.category_name AS [Category], pd.product_id, pd.product_name AS [Product], 
SUM(sls.qty) AS [Total Quantity],RANK() OVER(PARTITION BY pd.category_id ORDER BY SUM(sls.qty)) AS [Ranked Products]
FROM saless AS sls
INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
GROUP BY pd.category_id, pd.category_name, pd.product_id, pd.product_name
)r
WHERE r.[Ranked Products] = 1

````


**Answer:**

![Screen Shot 2023-07-10 at 5 49 47 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/f1ea6101-ec3a-4b6b-b0e7-6e675180b4cc)


- We can see that the Cream Relaxed Jeans is the top ranked product for the Women with a total amount of 3707.
- We can also see that the Teal Buttom up Shirt is the top ranked product for the Men with a total amount of 3646.
***


### 6. What is the percentage split of revenue by product for each segment?
- We will first create a CTE that calculates the total revenue.
- We will use the CTE to calculate the percent split of revenue by product for each segment.
- We will use a a SUM() OVER( Order By) technique as well to find running total combinations to get the revenue percentage split


````sql

rev AS
(
SELECT pd.segment_id, pd.segment_name AS [Segment], pd.product_id, pd.product_name AS [Product], SUM(qty) AS [Total Quantity], SUM(sls.qty * sls.price) AS [Total Revenue before Discount]
FROM saless AS sls
INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
GROUP BY pd.segment_id, pd.segment_name, pd.product_id, pd.product_name
)

SELECT *, 
ROUND(100 *[Total Revenue before Discount] / (SUM([Total Revenue before Discount] ) OVER (PARTITION BY segment_id)), 2) AS [Revenue Percentage Split]
FROM rev
ORDER BY segment_id, [Revenue Percentage Split] DESC

````


**Answer:**
![Screen Shot 2023-07-11 at 2 58 32 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/2b2bc5f6-7d6e-424d-8560-2353ab80a36c)



***

- Same thing as question 6 except we splitting the revenue by segment for each category

### 7. What is the percentage split of revenue by segment for each category?



````sql

rev2 AS
(
SELECT pd.category_id, pd.category_name AS [Category], pd.product_id, pd.product_name AS [Product], SUM(qty) AS [Total Quantity], SUM(sls.qty * sls.price) AS [Total Revenue before Discount]
FROM saless AS sls
INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
GROUP BY pd.category_id, pd.category_name, pd.product_id, pd.product_name
)

SELECT *, 
ROUND(100 *[Total Revenue before Discount] / (SUM([Total Revenue before Discount] ) OVER (PARTITION BY category_id)), 2) AS [Revenue Percentage Split]
FROM rev2
ORDER BY category_id, [Revenue Percentage Split] DESC

````



**Answer:**

![Screen Shot 2023-07-11 at 3 46 43 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/e144dcd6-9de1-4c01-a417-fb47b2ff603b)



***


### 8. What is the percentage split of total revenue by category?

- We will pull the category information then calculate the revenue divided by total revenue combinations calculations (by pulling the revenue again from the saless CTE through a subquery select or a self join).


````sql
SELECT pd.category_id, pd.category_name AS [Category], ROUND(100 * CAST(SUM(sls.qty * sls.price) AS FLOAT) / (SELECT SUM(qty * price) FROM saless), 2) AS [Revenue Percentage Split]
FROM saless AS sls
INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
GROUP BY pd.category_id, pd.category_name

````


**Answer:**

![Screen Shot 2023-07-11 at 4 07 42 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/74645e6b-1356-4c68-b1e1-1e3bcfea0997)

***


### 9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)

- As mentioned by Danny Ma, we can get the Penetration by getting the number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions. The penetration formula is displayed in the query below

````sql
SELECT pd.product_id, pd.product_name, 
ROUND(CAST (COUNT(sls.txn_id) AS FLOAT)/ (SELECT COUNT(DISTINCT txn_id) FROM saless), 2) AS [Penetration]
FROM saless AS sls
INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
GROUP BY pd.product_id, pd.product_name
ORDER BY Penetration

````


**Answer:**


![Screen Shot 2023-07-11 at 4 21 14 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/ebcd329c-34d0-4254-a234-aebd8f97427b)

***

- We can solve for this problem by getting the frequency of the possible combinations of any 3 products in a single transaction.
- We will need to find the number of combinations of 3 products out of the 12 Distinct(Unique) products.
- We can get the possible combinations by self joining the saless CTE twice and we can calculate the frequency

### 10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?


````sql

SELECT TOP 1 s.prod_id, s2.prod_id, s3.prod_id, COUNT(*) AS [Combinations]
FROM saless s 
JOIN saless s2 ON s2.txn_id = s.txn_id AND s.prod_id < s2.prod_id
JOIN saless s3 ON s3.txn_id = s.txn_id AND s2.prod_id < s3.prod_id
GROUP BY s.prod_id, s2.prod_id, s3.prod_id
ORDER BY Combinations DESC

````


**Answer:**

![Screen Shot 2023-07-11 at 4 40 48 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/8b5ac6db-0c13-40ec-8b00-6f2ea397b1da)


- From this query we see that the most common combination of any 3 products for one transaction are the following: 5d267b	9ec847 and	c8d436. And we can see that their combination occurred 352 times.

Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%207%20Balanced%20Tree%20Clothing%20Co/D.%20Reporting%20Challenge.md) for solution to D. Reporting Challenge

***

