# Case Study #6 - Clique Bait

## Solution - B. Product Funnel Analysis

### 1. Using a single SQL query - create a new output table which has the following details:

- How many times was each product viewed?
- How many times was each product added to cart?
- How many times was each product added to a cart but not purchased (abandoned)?
- How many times was each product purchased?
- Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.


## Use your 2 new output tables - answer the following questions:

- Which product had the most views, cart adds and purchases?
- Which product was most likely to be abandoned?
- Which product had the highest view to purchase percentage?
- What is the average conversion rate from view to cart add?
- What is the average conversion rate from cart add to purchase?

***

### Part 1 
- we will first get the page views and cart adds calculation from the Case statements that we created from the columns in PART A but we will put them in a CTE  while grabbing the product name and product id and visit id.

````sql

WITH pevents AS(
  
  SELECT e.visit_id, p.product_id, p.page_name, p.product_category, e.cookie_id, e.event_type, SUM(CASE WHEN i.event_name = 'Page View' THEN 1 ELSE 0 END) AS page_views,
SUM(CASE WHEN i.event_name = 'Add to Cart' THEN 1 ELSE 0 END) AS
add_to_cart
  FROM clique_bait.events  as e
  LEFT join clique_bait.page_hierarchy p on e.page_id = p.page_id
  LEFT  JOIN clique_bait.event_identifier AS i ON e.event_type = i.event_type
  WHERE p.product_id IS NOT NULL
  GROUP BY e.visit_id, p.product_id, p.page_name, p.product_category, e.cookie_id, e.event_type
),
````
- Next we will create a 2nd CTE to only grab the number of unique visitors that have made purchases


````sql
purchased_visitors AS(
  
  SELECT DISTINCT visit_id as purchased
  FROM clique_bait.events 
  WHERE event_type = 3 
),

````

- Then we will get the final CTE called product funnel that grabs everything from the first two CTES and then we calculate the count of page views, the count of cart additions and purchased products and then to calculate the number of abandoned products, we will subtract the number of purchased products in the cart from the number of products in the cart.

````sql
ProductFunnel AS(
 SELECT p.page_name AS product_name, p.product_id AS product_number, p.product_category, COUNT(p.page_views) AS views, COUNT(p.add_to_cart) AS cart_adds, COUNT(pv.purchased) AS product_purchased, COUNT(p.add_to_cart) - COUNT(pv.purchased) AS product_abandoned
FROM pevents AS p
LEFT JOIN purchased_visitors AS pv ON pv.purchased = p.visit_id
GROUP BY p.page_name, p.product_id, p.product_category
)


SELECT *
FROM productFunnel

````

**Answer:**
![Screen Shot 2023-07-03 at 8 55 47 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/74e66dbb-8666-445f-a51b-a9489780e934)

***

### Part 2

- Same CTEs as part one but the last CTE will be focusing more on product category rather than the individual products and the product names themselves.
- we will first get the page views and cart adds calculation from the Case statements that we created from the columns in PART A but we will put them in a CTE  while grabbing the product name and product id and visit id.

````SQL

WITH pevents AS(
  
  SELECT e.visit_id, p.product_id, p.page_name, p.product_category, e.cookie_id, e.event_type, SUM(CASE WHEN i.event_name = 'Page View' THEN 1 ELSE 0 END) AS page_views,
SUM(CASE WHEN i.event_name = 'Add to Cart' THEN 1 ELSE 0 END) AS
add_to_cart
  FROM clique_bait.events  as e
  LEFT join clique_bait.page_hierarchy p on e.page_id = p.page_id
  LEFT  JOIN clique_bait.event_identifier AS i ON e.event_type = i.event_type
  WHERE p.product_id IS NOT NULL
  GROUP BY e.visit_id, p.product_id, p.page_name, p.product_category, e.cookie_id, e.event_type
),
````


- Next we will create a 2nd CTE to only grab the number of unique visitors that have made purchases
````sql
purchased_visitors AS(
  
  SELECT DISTINCT visit_id as purchased
  FROM clique_bait.events 
  WHERE event_type = 3 
),

````


- Then we will get the final CTE called product funnel that grabs everything from the first two CTES and then we calculate the count of page views, the count of cart additions and purchased products and then to calculate the number of abandoned products, we will subtract the number of purchased products in the cart from the number of products in the cart.

````sql
ProductFunnel2 AS(
 SELECT p.product_category, COUNT(p.page_views) AS views, COUNT(p.add_to_cart) AS cart_adds, COUNT(pv.purchased) AS product_purchased, COUNT(p.add_to_cart) - COUNT(pv.purchased) AS product_abandoned
FROM pevents AS p
LEFT JOIN purchased_visitors AS pv ON pv.purchased = p.visit_id
GROUP BY p.product_category
)


SELECT *
FROM productFunnel2

````
**Answer:**


![Screen Shot 2023-07-03 at 9 02 23 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/c7546b6f-421a-4d67-af44-071ca8be96f9)


***

1. Which product had the most views, cart adds and purchases?
- Most views:

````SQL
SELECT product_number, product_name, views
FROM ProductFunnel
ORDER BY views DESC
````
- Lobster has the Most views

- Most cart adds:

  
````SQL
SELECT product_number, product_name, cart_adds
FROM ProductFunnel
ORDER BY cart_adds DESC
````
- Lobster has the most cart adds


- Most Purchases

  
````SQL
SELECT product_number, product_name, product_purchased
FROM ProductFunnel
ORDER BY product_purchased DESC
````
- Lobster has the most purchases

2. Which product was most likely to be abandoned?


````SQL
SELECT product_number, product_name, product_purchased
FROM ProductFunnel
ORDER BY product_purchased DESC
````
- Russian Caviar is the product that is the most abandoned.


3. Which product had the highest view to purchase percentage?

````SQL
SELECT product_number, product_name, round(100*(product_purchased/views), 2) AS percentage_of_purchase
FROM productFunnel
ORDER BY percentage_of_purchase DESC
LIMIT 1
````

- Lobster has the highest view to purchase percentage at 48.74%.

4. What is the average conversion rate from view to cart add?
5. What is the average conversion rate from cart add to purchase?

````SQL
SELECT  ROUND(100*AVG(cart_adds/views),2) AS avg_view_to_cart_add_conversion,
ROUND(100*AVG(product_purchased/cart_adds),2) AS avg_cart_add_to_purchases_conversion_rate
FROM ProductFunnel
````

- Average views to cart adds rate is 60.95% and average cart adds to purchases rate is 75.93%.

Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%206%20Clique%20Bait/C.%20Campaigns%20Analysis.md) for solution to C. Campaigns Analysis

***
