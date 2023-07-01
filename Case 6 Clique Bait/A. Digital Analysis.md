# Case Study #6 - Clique Bait

## Solution - A. Digital Analysis

### 1. How many users are there?

We will create a CTE called users to combine the data of the two clique bait users table

````sql
WITH users AS(
SELECT *
FROM CliqueBait_Users
UNION
SELECT *
FROM CliqueBait_Users2
)

SELECT COUNT(DISTINCT user_id ) AS [Number of Users]
FROM Users
````

**Answer:**

![Screen Shot 2023-07-01 at 3 08 56 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/b1c887c7-9710-460d-8616-ec85009ba306)


***

## 2. How many cookies does each user have on average?

We will create a CTE called users to combine the data of the two clique bait users table

````sql
WITH users AS(
SELECT *
FROM CliqueBait_Users
UNION
SELECT *
FROM CliqueBait_Users2
)

SELECT AVG(avg.[Number of Cookies]) AS [Average Number of cookies]
FROM
(
SELECT user_id, COUNT(cookie_id) AS [Number of Cookies]
FROM Users
GROUP BY user_id
)avg

````

**Answer:**

![Screen Shot 2023-07-01 at 3 12 00 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/f4061816-648a-45fe-afa5-82fb34a079b1)

***

### 3. What is the unique number of visits by all users per month?

- Postgres SQL code.

- This query was created with Postgres so we used a Postgres version of Date part to get the month of the event and counted the number of unique visits per month.

````sql
SELECT COUNT(DISTINCT visit_id) AS Number_of_Unique_Visits,
DATE_PART('month', event_time) AS Month --Postgres version of DATEPART
FROM clique_bait.events
GROUP BY DATE_PART('month', event_time);

````

**Answer:**
![Screen Shot 2023-07-01 at 3 16 11 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/c10e4aae-d70b-458a-8d42-a41fa518d662)

***



### 4. What is the number of events for each event type?

Postgres SQL code

````sql
SELECT event_type, COUNT(*) AS Number_of_events
FROM clique_bait.events 
Group BY event_type
Order By event_type
````


**Answer:**

![Screen Shot 2023-07-01 at 3 18 41 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/22b3e8d2-7149-4f1c-86ae-6a7a45ee5af9)


***

### 5. What is the percentage of visits which have a purchase event?

Also done in Postgres SQL

To answer this question, we will need the event name filtered by purchase from the event table and joined with the events

In order to get the percentage of visits based on the purchase event.

````sql

SELECT 100 * COUNT(DISTINCT e.visit_id)/
    (SELECT COUNT(DISTINCT visit_id) FROM clique_bait.events) AS percentage_purchase
FROM clique_bait.events AS e
FULL JOIN clique_bait.event_identifier AS i
ON e.event_type = i.event_type
WHERE i.event_name = 'Purchase'
LIMIT 10;

````
![Screen Shot 2023-07-01 at 3 20 38 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/50b041bb-c463-405e-90f6-9b41b3fc408e)


**Answer:**


***

### 6. What is the percentage of visits which view the checkout page but do not have a purchase event?


The strategy to answer this question is to breakdown the question into 2 parts.

- First we will create subquery to categorize the checkout page and the purchase event using the events table and the event identifier table, we will use the MAX on the Case statements to avoid grouping the results by the event type and the page id.
- The main query will the be sused to find the percentage of the visits which viewed the checkout page.
- The query is done in Postgres SQL

````sql
SELECT 
ROUND(100 * (1-(SUM(e.purchase)::numeric/SUM(e.checkout))),2) AS perc_checkout_view_with_no_purchase
FROM
(
SELECT e.visit_id,
MAX(CASE WHEN i.event_name = 'Page View' AND e.page_id = 12 THEN 1 ELSE 0 END) AS checkout,
MAX(CASE WHEN i.event_name = 'Purchase' THEN 1 ELSE 0 END) AS purchase
FROM clique_bait.events AS e
FULL JOIN clique_bait.event_identifier AS i
ON e.event_type = i.event_type
GROUP BY e.visit_id
)e
LIMIT 100;

````


**Answer:**

- The percentage of visits which view the checkout page but do not have a purchase event is 15.50 percent

***

### 7. What are the top 3 pages by number of views?

- We want to find the top 3 pages and their number of views in descending order.
- Because this query is done in PostGres SQL, we will use the LIMIT 3 function instead of SELECT TOP 3 function to get the top 3 pages.
- We will use the events table to pull the number of views and get the page names from the page table. We will get the event name "page view" from the event identifier table.

````sql


SELECT ph.page_name, 
  COUNT(e.*) AS page_views
FROM clique_bait.events AS e
LEFT JOIN clique_bait.page_hierarchy AS PH
ON e.page_id = ph.page_id
LEFT JOIN clique_bait.event_identifier AS i
ON e.event_type = i.event_type
WHERE i.event_name = 'Page View' AND e.event_type = 1 
GROUP BY ph.page_name
ORDER BY page_views DESC
LIMIT 3;


````


**Answer:**
![Screen Shot 2023-07-01 at 3 37 06 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/385196e0-41e7-4534-8cc4-7b0ee45ce5d8)


***

### 8. What is the number of views and cart adds for each product category?

- We will need to calculate the number of views and add to cart values per product category and we will do this by creating a sum case statement to get the number of page views and add to cart values per category.
- We will query this in postgres sql as well.

````sql
SELECT ph.product_category,
SUM(CASE WHEN i.event_name = 'Page View' THEN 1 ELSE 0 END) AS page_views,

SUM(CASE WHEN i.event_name = 'Add to Cart' THEN 1 ELSE 0 END) AS
add_to_cart
FROM clique_bait.events AS e
LEFT JOIN clique_bait.page_hierarchy AS PH
ON e.page_id = ph.page_id
LEFT  JOIN clique_bait.event_identifier AS i
ON e.event_type = i.event_type
WHERE ph.product_category IS NOT NULL
GROUP BY ph.product_category
````


**Answer:**

![Screen Shot 2023-07-01 at 3 34 06 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/142cd5c1-7b1b-4079-a704-f3c9ac26d69a)


***

### 9. What are the top 3 products by purchases?

````sql



````


**Answer:**


