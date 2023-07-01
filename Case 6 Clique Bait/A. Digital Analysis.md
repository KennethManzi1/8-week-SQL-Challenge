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
***

![Screen Shot 2023-07-01 at 3 12 00 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/f4061816-648a-45fe-afa5-82fb34a079b1)



### 3. What is the unique number of visits by all users per month?

````sql



````


**Answer:**
***

### 4. What is the number of events for each event type?

````sql



````


**Answer:**
***

### 5. What is the percentage of visits which have a purchase event?

````sql



````


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


