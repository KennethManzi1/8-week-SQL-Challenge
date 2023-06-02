--Creating the Pizza Runner Database
USE master;
GO

IF NOT EXISTS (
      SELECT name
      FROM sys.databases
      WHERE name = N'TutorialDB'
      )
   CREATE DATABASE [Pizza_runner];
GO

IF SERVERPROPERTY('ProductVersion') > '12'
   ALTER DATABASE [Pizza_runner] SET QUERY_STORE = ON;
GO

-- Creating Runners Table and inserting the data

DROP TABLE IF EXISTS dbo.runners;
CREATE TABLE dbo.runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO dbo.runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


--Creating the Customer Orders table and inserting the data
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
  ('4', '103', '1', '4', NULL, '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', NULL, '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', NULL, '2020-01-04 13:23:46'),
  ('5', '104', '1', NULL, '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', NULL, NULL, '2020-01-08 21:03:13'),
  ('7', '105', '2', NULL, '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', NULL, NULL, '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1', '2020-01-10 11:22:59'),
  ('9', '103', '1', '4', '5', '2020-01-10 11:22:59'),
  ('10', '104', '1', NULL, NULL, '2020-01-11 18:34:49'),
  ('10', '104', '1', '2', '1', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2', '4', '2020-01-11 18:34:49'),
  ('10', '104', '1', '6', '1', '2020-01-11 18:34:49'),
  ('10', '104', '1', '6', '4', '2020-01-11 18:34:49');


--Creating the Runners Orders table and inserting the data
DROP TABLE IF EXISTS dbo.runner_orders;
CREATE TABLE dbo.runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" DATETIME,
  "distance in km" FLOAT,
  "duration in minutes" INTEGER,
  "cancellation" VARCHAR(23)
);

INSERT INTO dbo.runner_orders
  ("order_id", "runner_id", "pickup_time", "distance in km", "duration in minutes", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20', '32', NULL),
  ('2', '1', '2020-01-01 19:10:54', '20', '27', NULL),
  ('3', '1', '2020-01-03 00:12:37', '13.4', '20', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', NULL, '0', '0', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25', '25', NULL),
  ('8', '2', '2020-01-10 00:15:02', '23.4', '15', NULL),
  ('9', '2', NULL, '0', '0','Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10', '10', NULL);

--Creating the Pizza Names table and inserting the data
DROP TABLE IF EXISTS dbo.pizza_names;
CREATE TABLE dbo.pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" NVARCHAR(100)
);
INSERT INTO dbo.pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

--Creating the Pizza Recipes table and inserting the data

DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" NVARCHAR(100)
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

--Creating the Pizza Toppings table and inserting the data

DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" NVARCHAR(100)
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
 
 /*Case Study 2 questions
A. Pizza Metrics
1. How many pizzas were ordered?
    18 Pizzas were orders

2. How many unique customer orders were made?
    10 Unique customer orders were made 

3. How many successful orders were delivered by each runner?
    Runner 1 has 4 successful delivered orders.
   Runner 2 has 3 successful delivered orders.
   Runner 3 has 1 successful delivered order.

4. How many of each type of pizza was delivered?
    12 Meatlovers Pizza were delivered
    3 Vegetarian Pizza were delivered

5. How many Vegetarian and Meatlovers were ordered by each customer?
    14 Meatlovers and 4 Vegeterians.

6.  What was the maximum number of pizzas delivered in a single order?
    5 pizzas

7.  For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
      Customer 101 and 102 likes his/her pizzas per the original recipe.
     Customer 103, 104 and 105 have their own preference for pizza topping and requested at least 1 change (extra or exclusion topping) on their pizza.


8.  How many pizzas were delivered that had both exclusions and extras?
    4 Pizzas had both exclusions and extras

9.  What was the total volume of pizzas ordered for each hour of the day?
    hour 11 is 2 pizzas
    hour 13 is 3 pizzas
    hour 18 is 6 pizzas
    hour 19 is 1 pizza
    hour 21 is 3 pizzas
    hour 23 is 3 pizzas

10. What was the volume of orders for each day of the week?
Friday had a volume of 5 pizzas
Monday had a volume of 8 pizzas
Saturday had a volume of 3 pizzas
Sunday had a volume of 2 pizzas

 */

--SQL Query to answer the Case study questions for A. Pizza Metrics
--Question 1 SQL
SELECT COUNT(*) AS pizza_order_count
FROM dbo.customer_orders

--Question 2 SQL
SELECT COUNT(DISTINCT dbo.customer_orders.order_id) AS pizza_order_count
FROM dbo.customer_orders

--Question 3 SQL
SELECT runner_id, COUNT(order_id) AS [successful orders]
FROM dbo.runner_orders
WHERE [distance in km]!= 0
GROUP BY runner_id;


--Question 4 SQL

SELECT COUNT(c.pizza_id) AS delivered_pizza_count --p.*--, pizza_name
FROM dbo.customer_orders AS c
JOIN dbo.runner_orders AS r
  ON c.order_id = r.order_id
JOIN dbo.pizza_names AS p
  ON c.pizza_id = p.pizza_id
WHERE r.[distance in km]!= 0 --and --p.pizza_name --LIKE '%Meatlovers%'
--GROUP BY p.pizza_id, p.pizza_name

--Question 5 SQL

SELECT  c.customer_id, p.pizza_name 
FROM dbo.customer_orders AS c
JOIN dbo.pizza_names AS p
  ON c.pizza_id= p.pizza_id
--GROUP BY c.customer_id
ORDER BY c.customer_id;

--Question 6 SQL
SELECT MAX(M.pizza_per_order) AS [Maximum Number of Pizzas Delivered]
FROM
(
SELECT orders.order_id, COUNT(orders.pizza_id) AS pizza_per_order
FROM dbo.customer_orders AS orders
JOIN dbo.pizza_names AS NAMES ON orders.pizza_id = names.pizza_id
INNER JOIN dbo.runner_orders as rord ON orders.order_id = rord.order_id
GROUP BY orders.order_Id
)M
--Question 7 SQL
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

--Question 8 SQL
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



--Question 9 SQL
SELECT DATEPART(HOUR, order_time) AS hour_of_day, COUNT(order_id) AS pizza_count
FROM dbo.customer_orders
GROUP BY DATEPART(HOUR, order_time) 

--Question 10 SQL
SELECT FORMAT(DATEADD(DAY, 2, order_time) ,'dddd')AS day_of_the_week, COUNT(order_id) AS pizza_count
FROM dbo.customer_orders
GROUP BY FORMAT(DATEADD(DAY, 2, order_time) ,'dddd')

/*
B. Runner and Customer Experience
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
      Week 1: 1 runner registered
      Week 2: 2 runners registered
      Week 3: 1 Runner Registered
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
    The average time taken in minutes by runners to arrive at Pizza Runner HQ to pick up the order is 18 minutes.

3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
    On Average an order with 1 pizza takes 12 minutes to prepare
    An order with 2 pizzas takes 21 minutes to prepare
    An order with 3 pizzas will take 30 minutes to prepare

4. What was the average distance travelled for each customer?
    Customer 104 had an average distance of 10 km.
    Customer 102 had an average distance of 16.73 km.
    Customer 105 had an average distance of 25 km.
    Customer 103 had an average distance of 23.39 km.

5. What was the difference between the longest and shortest delivery times for all orders?
    The difference between the longest and Shortest Delivery Times is 30

6. What was the average speed for each runner for each delivery and do you notice any trend for these values? (Average speed = Distance in km / Duration in hour)
    Runner 1’s average speed runs from 37.5km/h to 44.4 km/h.
    Runner 2’s average speed runs from 35.1km/h to 93.6km/h. Danny should investigate Runner 2 as the average speed has a 300% fluctuation rate!
    Runner 3’s average speed is 40km/h

7. What is the successful delivery percentage for each runner?
    Runner 1 has a 100% successful delivery percentage.
    Runner 2 has a 75% successful delivery percentage
    Runner 3 has a 50% successful delivery percentage.
*/

--SQL Query to answer the Case study questions for B. Runner and Customer Experience

--Runner Sign ups 
SELECT COUNT(runner_id) AS [Number of Runners signed up], DATEPART(WEEK, registration_date) AS [Registration Week]
FROM dbo.runners
GROUP BY DATEPART(WEEK, registration_date) 

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

--Average Distance 
SELECT c.customer_id, AVG(r.[distance in km]) AS [Average Distance per customer]--, r.[duration in minutes]
FROM customer_orders AS C
LEFT JOIN runner_orders as r  
ON c.order_id = r.order_id
WHERE r.[distance in km] != 0
GROUP BY c.customer_id--, r.[duration in minutes]

--difference between the longest and shortest delivery times for all orders
SELECT order_id, [duration in minutes]
FROM runner_orders

SELECT CAST(MAX([duration in minutes]) AS Numeric) - CAST(MIN([duration in minutes]) AS numeric) AS [Difference between Longest and Shortest Delivery Times]
FROM runner_orders
WHERE [duration in minutes] != 0

--What was the average speed for each runner for each delivery (Average speed = Distance in km / Duration in hour)

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

--Successful Delivery Percentage by each runner
SELECT runner_id,  ROUND(100 * SUM(
  CASE WHEN [distance in km] = 0 THEN 0 ELSE 1 END)/COUNT(*), 0) AS success_perc
FROM dbo.runner_orders
--WHERE [distance in km] != 0
GROUP BY runner_id

/*
C. Ingredient Optimisation
1. What are the standard ingredients for each pizza?
    Meatlovers: Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami
    Vegetarian: Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce

2. What was the most commonly added extra?
    The most commonly added Extra Topping was Bacon 

3. What was the most common exclusion?
    The most commonly Exclusion Topping was Cheese.

4. Generate an order item for each record in the customers_orders table in the format of one of the following:
      Meat Lovers
      Meat Lovers - Exclude Beef
      Meat Lovers - Extra Bacon
      Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
    For example: "Meat Lovers: 2xBacon, Beef, ... , Salami" What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

*/

--SQL Query to answer the Case study questions for C. Ingredient Optimisation
--standard ingredients for each pizza?

--Recreating the pizza_recipes table so that each table has pizza_id and its topping
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
(2,12, 'Tomato Sauce');





SELECT pizza.pizza_id, pizza.pizza_name, String_agg(pizza.topping_name,',') AS [Standard Ingredients]
FROM 
(
SELECT reci.pizza_id, pname.pizza_name, topp.topping_name
FROM pizza_recipes as reci
INNER JOIN pizza_toppings AS topp
ON reci.toppings = topping_id
INNER JOIN pizza_names AS pname 
ON reci.pizza_id = pname.pizza_id
)pizza
GROUP BY pizza.pizza_id, pizza.pizza_name


--Most Commonly Added Extra

--Creating an Extra topping CTE where we manipuate the toppings using Substrings For Extras.

WITH Extra AS
(
SELECT pizza_id, topping_type, topping
FROM 
(
  SELECT pizza_id, CAST(SUBSTRING(extras, 1, 1) AS INT) as [First Topping], CAST(SUBSTRING(extras,3,3) AS INT) AS [Second Topping]
  FROM dbo.customer_orders
  WHERE extras IS NOT NULL
  )pizza
  UNPIVOT (topping for topping_type in ([First Topping], [Second Topping])) as unpvt
)

SELECT E.Topping, p.topping_name, COUNT(E.topping) AS [Extra Topping Time]
FROM Extra AS E
INNER JOIN dbo.pizza_toppings p ON E.topping = p.topping_id
GROUP BY E.Topping,  P.topping_name

--the most common exclusion

--Creating an Exclu topping CTE where we manipuate the Toppings using Substrings for Exclusions.

WITH Exclu AS
(
SELECT pizza_id, topping_type, topping
FROM 
(
  SELECT pizza_id, CAST(SUBSTRING(exclusions, 1, 1) AS INT) as [First Exclusion], CAST(SUBSTRING(exclusions,3,3) AS INT) AS [Second Exclusion]
  FROM dbo.customer_orders
  WHERE exclusions IS NOT NULL
  )pizza
  UNPIVOT (topping for topping_type in ([First Exclusion], [Second Exclusion])) as unpvt
)

SELECT E.Topping, p.topping_name, COUNT(E.topping) AS [Exclusions Topping Time]
FROM Exclu AS E
INNER JOIN dbo.pizza_toppings p ON E.topping = p.topping_id
GROUP BY E.Topping,  p.topping_name

--Generate an order item for each record in the customers_orders table in the format of one of the following:
      --Meat Lovers
     -- Meat Lovers - Exclude Beef
     -- Meat Lovers - Extra Bacon
     -- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

SELECT cust.customer_id, cust.pizza_id, pizz.pizza_name, cust.exclusions, cust.extras,
CASE WHEN cust.pizza_id = 1 AND (cust.exclusions IS NULL or cust.exclusions = 0) AND (cust.extras IS NULL or cust.extras = 0) THEN 'Meat Lovers'
WHEN cust.pizza_id = 1 AND (cust.exclusions = 4) AND (cust.extras IS NULL or cust.extras = 0) THEN 'Meat Lovers - Exclude Cheese'
WHEN cust.pizza_id = 1 AND (cust.exclusions LIKE '%3%' or cust.exclusions = 3) AND (cust.extras IS NULL or cust.extras = 0) THEN 'Meat Lovers - Exclude Beef'
WHEN cust.pizza_id = 1 AND (cust.exclusions IS NULL or cust.exclusions = 0) AND (cust.extras LIKE '%1%' or cust.extras = 1) THEN 'Meat Lovers - Extra Bacon'
WHEN cust.pizza_id = 1 AND (cust.exclusions IN ('1, 4')) AND (cust.extras IN ('6, 9')) THEN ' Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers'
WHEN cust.pizza_id = 1 AND (cust.exclusions IN ('2, 6')) AND (cust.extras IN ('1, 4')) THEN ' Meat Lovers - Exclude BBQ Sauce, Mushroom - Extra Bacon, Cheese'
WHEN cust.pizza_id = 1 AND (cust.exclusions = 4 ) AND (cust.extras IN ('1, 5')) THEN ' Meat Lovers - Exclude Cheese - Extra Bacon, Chicken' 
WHEN cust.pizza_id = 2 AND (cust.exclusions IS NULL or cust.exclusions = 0) AND (cust.extras IS NULL or cust.extras = 0) THEN 'Vegeterian'
WHEN cust.pizza_id = 2 AND (cust.exclusions = 4) AND (cust.extras IS NULL or cust.extras = 0) THEN 'Vegeterian - Exclude Cheese' 
END AS [Order Item]
FROM dbo.customer_orders AS cust 
INNER JOIN dbo.pizza_names AS pizz 
ON pizz.pizza_id = cust.pizza_id

SELECT *
FROM customer_orders

--alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
--Adding the record identifier
ALTER TABLE dbo.customer_orders
ADD record_id INT IDENTITY (1,1)
--Creating Extras table
DROP TABLE IF EXISTS dbo.extras;
SELECT		
      c.record_id,
      TRIM(e.value) AS topping_id
INTO dbo.extras
FROM dbo.customer_orders as c
	    CROSS APPLY string_split(c.extras, ',') as e;
--Creating Exclusions table

DROP TABLE IF EXISTS dbo.exclusions;
SELECT c.record_id, TRIM(e.value) AS topping_id

INTO dbo.exclusions
FROM dbo.customer_orders as c
	    CROSS APPLY string_split(c.exclusions, ',') as e;

SELECT *
FROM dbo.exclusions

SELECT *
FROM dbo.pizza_recipes

--Quering for the ingredients and separating them by comma
--Ingredients CTE to get the ingredients together had to first create a table for the exclusions and extras above
WITH Ingredients AS(
SELECT cus.record_id, nm.pizza_name, pz.topping_name,
CASE WHEN pz.toppings IN(
    SELECT topping_id 
    FROM extras 
    WHERE cus.record_id = extras.record_Id
)
THEN '2x' + pz.Topping_name
ELSE pz.Topping_name END AS [Topping]
FROM dbo.customer_orders AS cus
INNER JOIN pizza_names AS nm on cus.pizza_id = nm.pizza_id
INNER JOIN pizza_recipes AS pz ON  cus.pizza_id = pz.pizza_id
WHERE pz.toppings NOT IN(
  SELECT exclusions.topping_id
  FROM exclusions
  WHERE exclusions.record_id = cus.record_id
)
)

SELECT record_id, CONCAT(pizza_name + ':' , String_AGG(topping, ',')) AS [Ingredients]
FROM Ingredients
GROUP BY record_id, pizza_name
ORDER BY record_id

--total quantity of each ingredient used in all delivered pizzas sorted by most frequent first

--Manipulated the Ingredients CTE to check for frequent times a topping was used 
WITH Ingredients_Toppings AS(
SELECT cus.record_id, nm.pizza_name, pz.topping_name,
CASE WHEN pz.toppings IN(
    SELECT topping_id 
    FROM extras 
    WHERE cus.record_id = extras.record_Id
)
THEN 2
ELSE 1
END AS [Number of Times A Topping Was Used]
FROM dbo.customer_orders AS cus
INNER JOIN pizza_names AS nm on cus.pizza_id = nm.pizza_id
INNER JOIN pizza_recipes AS pz ON  cus.pizza_id = pz.pizza_id
INNER JOIN dbo.runner_orders as rn ON cus.order_id = rn.order_id
WHERE pz.toppings NOT IN(
  SELECT exclusions.topping_id
  FROM exclusions
  WHERE exclusions.record_id = cus.record_id AND rn.cancellation IS NULL
)
)

SELECT topping_name, SUM([Number of TImes a Topping Was Used]) AS [Total Number of Times a Topping Was Used]
FROM Ingredients_Toppings
GROUP BY topping_name
ORDER by [Total Number of Times a Topping Was Used] DESC

/*
D. Pricing and Ratings
 ------ If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
 ------ What if there was an additional $1 charge for any pizza extras?
                  Add cheese is $1 extra
 --------- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
          how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
  --------- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
                customer_id
                order_id
                runner_id
                rating
                order_time
                pickup_time
                Time between order and pickup
                Delivery duration
                Average speed
                Total number of pizzas
   --------- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
             - how much money does Pizza Runner have left over after these deliveries?

*/

--SQL Query to answer the Case study questions for D. Pricing and Ratings

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

--- What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra

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
/*
Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
                customer_id
                order_id
                runner_id
                rating
                order_time
                pickup_time
                Time between order and pickup
                Delivery duration
                Average speed
                Total number of pizzas
*/

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

---If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

WITH total_cost AS (
SELECT cus.order_id, pz.pizza_name, SUM(
CASE WHEN pz.pizza_name = 'Meatlovers' THEN $12
WHEN pz.pizza_name = 'Vegetarian' THEN $10
END) AS [Cost of Pizza]
FROM dbo.pizza_names as pz
INNER JOIN dbo.customer_orders AS cus ON pz.pizza_id = cus.pizza_id
GROUP BY cus.order_id, pz.pizza_name
)


SELECT prof.revenue, prof.[Total Cost when paid 0.3 per km],   prof.revenue - prof.[Total Cost when paid 0.3 per km] AS [Profit]
FROM 
(
SELECT SUM(rn.[distance in km]) * 0.3 AS [Total Cost when paid 0.3 per km],
SUM(tc.[Cost of Pizza]) AS revenue
FROM total_cost AS tc 
FULL JOIN dbo.runner_orders AS rn ON tc.order_id = rn.order_id
WHERE rn.cancellation IS NULL
)prof