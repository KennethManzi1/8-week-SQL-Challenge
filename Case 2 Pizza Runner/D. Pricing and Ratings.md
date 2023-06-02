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
SELECT SUM(CASE WHEN rev.extras IS NULL THEN rev.[Cost of Pizza]
WHEN extras = 1 THEN rev.[Cost of Pizza] + 1
ELSE rev.[Cost of Pizza] + 2 END) AS total
FROM 
(
SELECT nm.pizza_id, nm.pizza_name,
CASE WHEN pizza_name = 'Meatlovers' THEN $12
WHEN pizza_name = 'Vegetarian' THEN $10
END AS [Cost of Pizza], cus.exclusions, cus.extras
FROM dbo.pizza_names as nm
INNER JOIN dbo.customer_orders as cus ON  nm.pizza_id = cus.pizza_id
INNER JOIN dbo.runner_orders as rn ON cus.order_id = rn.order_id
WHERE rn.cancellation IS NULL
)rev 

```

**Answer:**
- With an additional $1 charge for any pizza extras and with cheese an additional $1, the runner has a total revenue of $182.00


### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
```SQL
--Creating a table for additional ratings system that allows customers to rate their runner
DROP TABLE IF EXISTS dbo.ratings;
CREATE TABLE dbo.ratings
("order_id" INT,
"rating_value" INT);

INSERT INTO ratings(
  "order_id", "rating_value"
)
VALUES
(1,3),
(2,4),
(3,5),
(4,1),
(5,1),
(6,3),
(7,4),
(8,3),
(9,2),
(10,5);

SELECT *
FROM dbo.ratings

```
**Solution:**

![Screen Shot 2023-06-02 at 1 45 58 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/a55ec671-98cc-4bf3-aa6c-3a68a4435619)



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

```SQL

SELECT cus.customer_id, cus.order_id, rat.rating_value, cus.order_time, run.pickup_time, 
DATEPART(minute,(run.pickup_time - cus.order_time)) AS [Time between order and pickup],
run.[duration in minutes], ROUND(AVG((run.[distance in km]/run.[duration in minutes])*60),2) AS [Average Speed],
COUNT(pizza_id) AS [Number of Pizzas]
FROM dbo.customer_orders as cus
LEFT JOIN dbo.ratings AS rat ON cus.order_id = rat.order_id
LEFT JOIN dbo.runner_orders AS run ON cus.order_id = run.order_id
WHERE run.cancellation IS NULL
GROUP BY cus.customer_id, cus.order_id, rat.rating_value, cus.order_time, run.pickup_time, DATEPART(minute,(run.pickup_time - cus.order_time)),
run.[duration in minutes]
ORDER BY cus.customer_id




```


**Solution:**

![Screen Shot 2023-06-02 at 1 48 06 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/29996a72-6eb5-424d-99bb-10f107bfa76d)




### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

