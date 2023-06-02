# Case Study #2 Pizza Runner

## Solution - D. Pricing and Ratings

### 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?


```sql

-- Meat lovers pizza cost $12 and Vegetarian costs $10 and there wre no charges

SELECT SUM(c.[Cost of Pizza]) AS total_revenue--, run.[duration in minutes] 
FROM 
(
SELECT pizza_id, pizza_name,
CASE WHEN pizza_name = 'Meatlovers' THEN $12
WHEN pizza_name = 'Vegetarian' THEN $10
END AS [Cost of Pizza]
FROM dbo.pizza_names
)c
INNER JOIN customer_orders AS cust on c.pizza_id = cust.pizza_id
INNER JOIN runner_orders AS run ON cust.order_id = run.order_id
WHERE run.cancellation IS NULL
--GROUP BY run.[duration in minutes]

```

**Answer:**
- The runner has a total revenue of $174.00


### 2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra

```sql

```

**Answer:**



### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

### 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-  customer_id
-  order_id
-  runner_id
-  rating
-  order_time
-  pickup_time
-  Time between order and pickup
-  Delivery duration
-  Average speed
-  Total number of pizzas

### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

