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

### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

### 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients

### 6. For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

### 7. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
