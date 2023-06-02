# Case Study #2 Pizza Runner

<img src="https://user-images.githubusercontent.com/81607668/127271856-3c0d5b4a-baab-472c-9e24-3c1e3c3359b2.png" alt="Image" width="500" height="520">

## Table of Contents
- [Business Task](#business-task)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Case Study Questions](#case-study-questions)
- Solution
    - [A. Pizza Metrics](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%202%20Pizza%20Runner/A.%20Pizza%20Metrics.md)
    - [B. Runner and Customer Experience](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%202%20Pizza%20Runner/B.%20Runner%20and%20Customer%20Experience.md)
    - [C. Ingredient Optimisation](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%202%20Pizza%20Runner/C.%20Ingredient%20Optimisation.md)
    - [D. Pricing and Ratings](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%202%20Pizza%20Runner/D.%20Pricing%20and%20Ratings.md)



***

## Business Task
Danny is expanding his new Pizza Empire and at the same time, he wants to Uberize it, so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers. 

## Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/81607668/127271531-0b4da8c7-8b24-4a14-9093-0795c4fa037e.png)

## Case Study Questions

### A. Pizza Metrics

View my solution [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%202%20Pizza%20Runner/A.%20Pizza%20Metrics.md)

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

### B. Runner and Customer Experience

View my solution [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%202%20Pizza%20Runner/B.%20Runner%20and%20Customer%20Experience.md)

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

### C. Ingredient Optimisation

View my solution [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%202%20Pizza%20Runner/C.%20Ingredient%20Optimisation.md)

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
6. For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
7. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

### D. Pricing and Ratings

View my solution [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%202%20Pizza%20Runner/D.%20Pricing%20and%20Ratings.md)

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
- Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

### E. Bonus Questions

If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

```SQL


--BONUS
INSERT INTO dbo.pizza_names
 ("pizza_id", "pizza_name")
VALUES
  (3, 'Supreme')

  SELECT *
  FROM dbo.pizza_names

DROP TABLE IF EXISTS dbo.customer_orders;
CREATE TABLE dbo.customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" DATETIME
);

INSERT INTO dbo.customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', NULL, NULL, '2020-01-01 18:05:02'),
  ('2', '101', '1', NULL, NULL, '2020-01-01 19:00:52'),
  ('3', '102', '1', NULL, NULL, '2020-01-02 23:51:23'),
  ('3', '102', '2', NULL, NULL, '2020-01-02 23:51:23'),
  ('3', '102', '3', NULL, NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', NULL, '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', NULL, '2020-01-04 13:23:46'),
  ('4', '103', '3', '4', NULL, '2020-01-04 13:23:46'),
  ('5', '104', '1', NULL, '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', NULL, NULL, '2020-01-08 21:03:13'),
  ('6', '101', '3', NULL, NULL, '2020-01-08 21:03:13'),
  ('7', '105', '2', NULL, '1', '2020-01-08 21:20:29'),
  ('7', '105', '3', NULL, '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', NULL, NULL, '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1', '2020-01-10 11:22:59'),
  ('9', '103', '3', '4', '5', '2020-01-10 11:22:59'),
  ('10', '104', '1', NULL, NULL, '2020-01-11 18:34:49'),
  ('10', '104', '1', '2', '1', '2020-01-11 18:34:49'),
  ('10', '104', '3', '2', '4', '2020-01-11 18:34:49'),
  ('10', '104', '1', '6', '1', '2020-01-11 18:34:49'),
  ('10', '104', '3', '6', '4', '2020-01-11 18:34:49');


 

  SELECT *
  FROM dbo.customer_orders

DROP table if exists dbo.pizza_recipes;

CREATE TABLE dbo.pizza_recipes
(
  pizza_id int,
  toppings int,
  Topping_name nvarchar(150)
);

INSERT INTO dbo.pizza_recipes
VALUES
(1, 1, 'Bacon'),
(1,2,  'BBQ Sauce'),
(1,3 , 'Beef'),
(1,4, 'Cheese'),
(1,5, 'Chicken'),
(1, 6, 'Mushrooms'),
(1,8, 'Pepperoni'),
(1,10, 'Salami'),
(2,4, 'Cheese'),
(2,6, 'Mushrooms'),
(2,7, 'Onions'),
(2,9, 'Peppers'),
(2,11, 'Tomatoes'),
(2,12, 'Tomato Sauce'),
(3, 1,  'Bacon'),
(3,2,  'BBQ Sauce'),
(3,3 , 'Beef'),
(3,4, 'Cheese'),
(3,5, 'Chicken'),
(3, 6, 'Mushrooms'),
(3,7, 'Onions'),
(3,8, 'Pepperoni'),
(3,9, 'Peppers'),
(3,10, 'Salami'),
(2,11, 'Tomatoes'),
(2,12, 'Tomato Sauce')

SELECT cus.customer_id, pn.pizza_name,rec.Topping_name
FROM dbo.customer_orders AS cus 
LEFT JOIN dbo.pizza_names AS pn ON cus.pizza_id = pn.pizza_id
LEFT JOIN dbo.pizza_recipes AS rec ON cus.pizza_id = rec.pizza_id
WHERE pn.pizza_name = 'Supreme'
```
**Solution:**

![Screen Shot 2023-06-02 at 3 37 03 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/17e90723-804a-45c3-9460-02678a48fba1)


***
