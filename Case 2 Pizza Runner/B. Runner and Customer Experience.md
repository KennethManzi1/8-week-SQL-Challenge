# Case Study #2 Pizza Runner

## Solution - B. Runner and Customer Experience

### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

````sql
--Runner Sign ups 
SELECT COUNT(runner_id) AS [Number of Runners signed up], DATEPART(WEEK, registration_date) AS [Registration Week]
FROM dbo.runners
GROUP BY DATEPART(WEEK, registration_date) 
````

**Answer:**

- Week 1: 1 runner registered
- Week 2: 2 runners registered
- Week 3: 1 Runner Registered

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

````sql
--Average Pick up time
SELECT AVG(p.[Pickup Minutes]) AS [Average Pickup Minutes]
FROM
(
SELECT ro.runner_id, C.order_id, C.order_time, ro.pickup_time, DATEDIFF(MINUTE, c.order_time, ro.pickup_time) AS [Pickup Minutes]
FROM runner_orders AS ro
INNER JOIN customer_orders AS C ON  ro.order_id = c.order_id --We want to get the runners who picked up their orders in order to figure out how long it took them to get those orders on average in minutes.
WHERE ro.[distance in km] != 0
--GROUP BY ro.runner_id, ro.pickup_time, C.order_id, C.order_time
)p
WHERE p.[Pickup Minutes] > 1
````

**Answer:**

- The average time taken in minutes by runners to arrive at Pizza Runner HQ to pick up the order is 18 minutes.

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

````sql
--Relationship between number of pizzas and how long the order takes to prepare

SELECT --R.order_id, 
R.[Number of Pizzas Per Order], AVG(R.prep_time_minutes) AS [Average Prep time Minutes]
FROM  
(
SELECT c.order_id, COUNT(c.order_id) AS [Number of Pizzas Per Order], c.order_time,
r.pickup_time, DATEDIFF(MINUTE, c.order_time, r.pickup_time) AS prep_time_minutes
FROM customer_orders AS c
FULL JOIN runner_orders as r  
ON c.order_id = r.order_id
WHERE r.[distance in km] != 0
GROUP BY c.order_id, c.order_time, r.pickup_time
)R
GROUP BY R.[Number of Pizzas Per Order]--, R.order_id
````

**Answer:**

-  On Average an order with 1 pizza takes 12 minutes to prepare
-  An order with 2 pizzas takes 21 minutes to prepare
-  An order with 3 pizzas will take 30 minutes to prepare


### 4. What was the average distance travelled for each customer?

````sql
--Average Distance 
SELECT c.customer_id, AVG(r.[distance in km]) AS [Average Distance per customer]--, r.[duration in minutes]
FROM customer_orders AS C
LEFT JOIN runner_orders as r  
ON c.order_id = r.order_id
WHERE r.[distance in km] != 0
GROUP BY c.customer_id--, r.[duration in minutes]
````

**Answer:**


_ Customer 104 had an average distance of 10 km.
- Customer 102 had an average distance of 16.73 km.
- Customer 105 had an average distance of 25 km.
- Customer 103 had an average distance of 23.39 km.


### 5. What was the difference between the longest and shortest delivery times for all orders?



````sql
--difference between the longest and shortest delivery times for all orders
SELECT order_id, [duration in minutes]
FROM runner_orders

SELECT CAST(MAX([duration in minutes]) AS Numeric) - CAST(MIN([duration in minutes]) AS numeric) AS [Difference between Longest and Shortest Delivery Times]
FROM runner_orders
WHERE [duration in minutes] != 0
````



**Answer:**

- The difference between longest (40 minutes) and shortest (10 minutes) delivery time for all orders is 30 minutes.

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

````sql
SELECT d.*, ROUND((d.[distance in km]/d.[Duration in minutes]*60), 2) AS [Average Speed]
FROM 
(
SELECT r.runner_id, c.customer_id, c.order_id, COUNT(c.order_id) AS [Number of Pizzas], r.[duration in minutes],
r.[distance in km], (r.[duration in minutes]/60) AS [Duration Per Hour]
FROM runner_orders AS r 
INNER JOIN customer_orders as c 
ON r.order_id = c.order_id
WHERE r.[distance in km] ! = 0
Group BY r.runner_id, c.customer_id, c.order_id, r.[distance in km], r.[duration in minutes]
)d
WHERE d.[distance in km] != 0 
ORDER BY d.order_id
````

**Answer:**

_(Average speed = Distance in km / Duration in hour)_
- Runner 1’s average speed runs from 37.5km/h to 60km/h.
- Runner 2’s average speed runs from 35.1km/h to 93.6km/h. Danny should investigate Runner 2 as the average speed has a 300% fluctuation rate!
- Runner 3’s average speed is 40km/h

### 7. What is the successful delivery percentage for each runner?

````sql
SELECT runner_id,  ROUND(100 * SUM(
  CASE WHEN [distance in km] = 0 THEN 0 ELSE 1 END)/COUNT(*), 0) AS success_perc
FROM dbo.runner_orders
--WHERE [distance in km] != 0
GROUP BY runner_id
````

**Answer:**

- Runner 1 has 100% successful delivery.
- Runner 2 has 75% successful delivery.
- Runner 3 has 50% successful delivery

-One issue is cancelled deliveries which the runner can't do anything about that as a runner may have a lower successful delivery but this could be because he/she may have had a cancelled delivery which is out of their control.
***
