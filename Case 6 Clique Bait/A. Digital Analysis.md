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

Postgres SQL code.

This query was created with Postgres so we used a Postgres version of Date part to get the month of the event and 

counted the number of unique visits per month.

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

````sql



````


**Answer:**
***

### 7. What are the top 3 pages by number of views?

````sql



````


**Answer:**
***

### 8. What is the number of views and cart adds for each product category?

````sql



````


**Answer:**
***

### 9. What are the top 3 products by purchases?

````sql



````


**Answer:**


