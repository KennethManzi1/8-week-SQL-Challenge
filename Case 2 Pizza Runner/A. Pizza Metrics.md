# Case Study #2 - Pizza Runner

## Solution - A. Pizza Metrics

### 1. How many pizzas were ordered?

````sql
SELECT COUNT(*) AS pizza_order_count
FROM dbo.customer_orders
````

**Answer:**

- Total of 18 pizzas were ordered.

### 2. How many unique customer orders were made?

````sql
SELECT COUNT(DISTINCT dbo.customer_orders.order_id) AS pizza_order_count
FROM dbo.customer_orders
````

**Answer:**


- There are 10 unique customer orders.

### 3. How many successful orders were delivered by each runner?

````sql
SELECT runner_id, COUNT(order_id) AS [successful orders]
FROM dbo.runner_orders
WHERE [distance in km]!= 0
GROUP BY runner_id;
````

**Answer:**


- Runner 1 has 4 successful delivered orders.
- Runner 2 has 3 successful delivered orders.
- Runner 3 has 1 successful delivered order.

### 4. How many of each type of pizza was delivered?

````sql
SELECT COUNT(c.pizza_id) AS delivered_pizza_count --p.*--, pizza_name
FROM dbo.customer_orders AS c
JOIN dbo.runner_orders AS r
  ON c.order_id = r.order_id
JOIN dbo.pizza_names AS p
  ON c.pizza_id = p.pizza_id
WHERE r.[distance in km]!= 0 --and --p.pizza_name --LIKE '%Meatlovers%'
--GROUP BY p.pizza_id, p.pizza_name
````

**Answer:**


- There are 12 delivered Meatlovers pizzas and 3 Vegetarian pizzas.

### 5. How many Vegetarian and Meatlovers were ordered by each customer?**

````sql
SELECT  c.customer_id, p.pizza_name 
FROM dbo.customer_orders AS c
JOIN dbo.pizza_names AS p
  ON c.pizza_id= p.pizza_id
--GROUP BY c.customer_id
ORDER BY c.customer_id;
````

**Answer:**

- Customer 101 ordered 2 Meatlovers pizzas and 1 Vegetarian pizza.
- Customer 102 ordered 2 Meatlovers pizzas and 2 Vegetarian pizzas.
- Customer 103 ordered 4 Meatlovers pizzas and 1 Vegetarian pizza.
- Customer 104 ordered 5 Meatlovers pizza.
- Customer 105 ordered 1 Vegetarian pizza.

### 6. What was the maximum number of pizzas delivered in a single order?

````sql
SELECT MAX(M.pizza_per_order) AS [Maximum Number of Pizzas Delivered]
FROM
(
SELECT orders.order_id, COUNT(orders.pizza_id) AS pizza_per_order
FROM dbo.customer_orders AS orders
JOIN dbo.pizza_names AS NAMES ON orders.pizza_id = names.pizza_id
INNER JOIN dbo.runner_orders as rord ON orders.order_id = rord.order_id
GROUP BY orders.order_Id
)M
````

**Answer:**


- Maximum number of pizza delivered in a single order is 5 pizzas.

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

````sql
SELECT orders.customer_id, orders.order_time,  orders.exclusions, orders.extras, rord.pickup_time, rord.cancellation,
SUM(CASE WHEN orders.exclusions IS NOT NULL OR orders.extras IS NOT NULL THEN 1 ELSE 0 END) AS at_least_1_change,
SUM(CASE WHEN orders.exclusions IS NULL AND orders.extras IS  NULL THEN 1 ELSE 0 END) AS no_change
FROM dbo.customer_orders AS orders
JOIN dbo.pizza_names AS NAMES ON orders.pizza_id = names.pizza_id
INNER JOIN dbo.runner_orders as rord ON orders.order_id = rord.order_id
WHERE rord.pickup_time IS NOT NULL
GROUP BY orders.customer_id, orders.order_time, orders.exclusions, orders.extras, rord.pickup_time, rord.cancellation--, orders.order_time,  orders.exclusions, orders.extras, names.pizza_name, rord.pickup_time, rord.cancellation
--WHERE CAST(pizza_name AS VARCHAR(150)) = 'Meatlovers'
--WHERE rord.pickup_time IS NOT NULL AND (orders.exclusions IS NULL AND orders.extras IS NULL)
--WHERE rord.pickup_time IS NOT NULL AND (orders.exclusions IS NOT NULL AND orders.extras IS NOT NULL)
--GROUP by orders.order_id, orders.order_time, names.pizza_name, rord.pickup_time

````

**Answer:**

- Customer 101 and 102 likes his/her pizzas per the original recipe.
- Customer 103, 104 and 105 have their own preference for pizza topping and requested at least 1 change (extra or exclusion topping) on their pizza.

### 8. How many pizzas were delivered that had both exclusions and extras?

````sql
SELECT orders.customer_id, orders.order_time,  orders.exclusions, orders.extras, rord.pickup_time, rord.cancellation,
SUM(CASE WHEN orders.exclusions IS NOT NULL OR orders.extras IS NOT NULL THEN 1 ELSE 0 END) AS at_least_1_change,
SUM(CASE WHEN orders.exclusions IS NULL AND orders.extras IS  NULL THEN 1 ELSE 0 END) AS no_change
FROM dbo.customer_orders AS orders
JOIN dbo.pizza_names AS NAMES ON orders.pizza_id = names.pizza_id
INNER JOIN dbo.runner_orders as rord ON orders.order_id = rord.order_id
WHERE rord.pickup_time IS NOT NULL AND (orders.exclusions IS NOT NULL AND orders.extras IS NOT NULL)
GROUP BY orders.customer_id, orders.order_time, orders.exclusions, orders.extras, rord.pickup_time, rord.cancellation--, orders.order_time,  orders.exclusions, orders.extras, names.pizza_name, rord.pickup_time, rord.cancellation
--WHERE CAST(pizza_name AS VARCHAR(150)) = 'Meatlovers'
--WHERE rord.pickup_time IS NOT NULL AND (orders.exclusions IS NULL AND orders.extras IS NULL)
--GROUP by orders.order_id, orders.order_time, names.pizza_name, rord.pickup_time


````

**Answer:**

- Only 4 pizzas delivered that had both extra and exclusion topping. 

### 9. What was the total volume of pizzas ordered for each hour of the day?

````sql
SELECT DATEPART(HOUR, order_time) AS hour_of_day, COUNT(order_id) AS pizza_count
FROM dbo.customer_orders
GROUP BY DATEPART(HOUR, order_time) 
````

**Answer:**

 hour 11 is 2 pizzas
 
 hour 13 is 3 pizzas
 
 hour 18 is 6 pizzas
 
 hour 19 is 1 pizza
 
 hour 21 is 3 pizzas
 
 hour 23 is 3 pizzas
 

### 10. What was the volume of orders for each day of the week?

````sql
SELECT FORMAT(DATEADD(DAY, 2, order_time) ,'dddd')AS day_of_the_week, COUNT(order_id) AS pizza_count
FROM dbo.customer_orders
GROUP BY FORMAT(DATEADD(DAY, 2, order_time) ,'dddd')
````

**Answer:**


Friday had a volume of 5 pizzas

Monday had a volume of 8 pizzas

Saturday had a volume of 3 pizzas

Sunday had a volume of 2 pizzas


***Click [here] for solution for B. Runner and Customer Experience!

