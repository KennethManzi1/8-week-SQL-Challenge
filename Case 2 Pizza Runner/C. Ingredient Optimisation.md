# Case Study #2 Pizza Runner

## Solution - C. Ingredient Optimisation

### 1. What are the standard ingredients for each pizza?
```sql
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




--Code to get the ingredients 
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

```
**Answer**
- Meatlovers: Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami,Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami
- Vegetarian: Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce,Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce


![Screen Shot 2023-06-01 at 11 04 18 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/e91df737-606c-44a3-816b-c5cd065d6c91)




### 2. What was the most commonly added extra?

```sql
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

```

**Answer**
- The most commonly added topping was Bacon with 5.
- Cheese was next topping with 2.
- Chicken was the least commonly added with 1.




### 3. What was the most common exclusion?

```sql
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
```
**Answer**
- The most commonly exclusion topping was cheese at 5.



### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

```sql
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

```
**Solution**

![Screen Shot 2023-06-01 at 10 58 29 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/4e586f49-ce6d-4cf4-8a2b-3fd9de7e44f7)


### 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients. For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

```sql
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

```
**Solution**

![Screen Shot 2023-06-01 at 11 08 52 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/128c3ec4-c3c2-4f5d-a6df-ff071869d4d1)


### 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

```sql
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

```
**Solution**

![Screen Shot 2023-06-01 at 11 22 42 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/44fc2b60-fa0a-4058-bc66-6db05c432dd5)


Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%202%20Pizza%20Runner/D.%20Pricing%20and%20Ratings.md) for solution for D. Pricing and Ratings!


