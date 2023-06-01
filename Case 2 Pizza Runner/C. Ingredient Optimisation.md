# 🍕 Case Study #2 Pizza Runner

## Solution - C. Ingredient Optimisation

### 1. What are the standard ingredients for each pizza?

### 2. What was the most commonly added extra?

```sql

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
-The most commonly added topping was Bacon with 5.
-Cheese was next topping with 2.
-Chicken was the least commonly added with 1.




### 3. What was the most common exclusion?

### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

### 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients

### 6. For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

### 7. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
