# 🍜 Case Study #1: Danny's Diner 
<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="500" height="520">

## 📚 Table of Contents
- [Business Task](#business-task)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Question and Solution](#question-and-solution)


***

## Business Task
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. 

## Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/81607668/127271130-dca9aedd-4ca9-4ed8-b6ec-1e1920dca4a8.png)

## Question and Solution

### 1. What is the total amount each customer spent at the restaurant?

````sql
--Customer A total Amount
SELECT SUM(mn.price) AS total_sales
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
WHERE sl.customer_id = 'A'
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
--ORDER BY sl.customer_id, mn.product_id

--Customer B total Amount
SELECT SUM(mn.price) AS total_sales
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
WHERE sl.customer_id = 'B'
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
--ORDER BY sl.customer_id, mn.product_id

--Customer C total Amount
SELECT SUM(mn.price) AS total_sales
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
WHERE sl.customer_id = 'C'
````

#### Answer:

- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.

***

### 2. How many days has each customer visited the restaurant?

````sql
SELECT customer_id, COUNT(DISTINCT(order_date)) AS [Number of Customers Visited]
FROM dbo.sales
GROUP BY customer_id;
````

#### Answer:

- Customer A visited 4 times.
- Customer B visited 6 times.
- Customer C visited 2 times.

***

### 3. What was the first item from the menu purchased by each customer?

````sql

SELECT c.customer_id, c.product_name
FROM
(
SELECT customer_id, order_date, product_name,
      ROW_NUMBER() OVER(PARTITION BY s.customer_id
      ORDER BY s.order_date) AS rownum
   FROM dbo.sales AS s
   JOIN dbo.menu AS m
      ON s.product_id = m.product_id
)c
WHERE c.rownum= 1
GROUP BY c.customer_id, c.product_name;
````

#### Answer:
| customer_id | product_name | 
| ----------- | ----------- |
| A           | sushi    | 
| B           | curry        | 
| C           | ramen        |

- Customer A's first order is sushi and B's first order is curry.
- Customer C's first order is ramen.

***

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

````sql
SELECT TOP 1 (COUNT(sl.product_id)) AS most_purchased, product_name
FROM dbo.sales AS sl
JOIN dbo.menu AS mn
   ON sl.product_id = mn.product_id
GROUP BY sl.product_id, product_name
ORDER BY most_purchased DESC;
````


#### Answer:
| most_purchased | product_name | 
| ----------- | ----------- |
| 8       | ramen |


- Most purchased item on the menu is ramen which is 8 times. 

***

### 5. Which item was the most popular for each customer?

````sql

SELECT Rn.customer_id, Rn.product_name, Rn.order_count
FROM 
(
   SELECT sl.customer_id, mn.product_name, COUNT(mn.product_id) AS order_count,
      DENSE_RANK() OVER(PARTITION BY sl.customer_id
      ORDER BY COUNT(sl.customer_id) DESC) AS rank
   FROM dbo.menu AS mn
   LEFT JOIN dbo.sales AS sl
      ON mn.product_id = sl.product_id
   GROUP BY sl.customer_id, mn.product_name
)Rn
WHERE Rn.rank = 1;
````

#### Answer:
| customer_id | product_name | order_count |
| ----------- | ---------- |------------  |
| A           | ramen        |  3   |
| B           | sushi        |  2   |
| B           | curry        |  2   |
| B           | ramen        |  2   |
| C           | ramen        |  3   |

- Customer A and C's favourite item is ramen.
- Customer B enjoys all items on the menu. He/she is a true foodie, sounds like me

***

### 6. Which item was purchased first by the customer after they became a member?

````sql
SELECT Rr.customer_id, Rr.order_date, m2.product_name 
FROM 
(
   SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY s.order_date) AS rank
   FROM sales AS s
   JOIN members AS m
      ON s.customer_id = m.customer_id
   WHERE s.order_date >= m.join_date
)Rr
JOIN menu AS m2
   ON Rr.product_id = m2.product_id
WHERE Rr.rank = 1;
````


#### Answer:
| customer_id | order_date  | product_name |
| ----------- | ---------- |----------  |
| A           | 2021-01-07 | curry        |
| B           | 2021-01-11 | sushi        |

- Customer A's first order as member is curry.
- Customer B's first order as member is sushi.

***

### 7. Which item was purchased just before the customer became a member?

````sql
SELECT Rr.customer_id, Rr.order_date, m2.product_name 
FROM 
(
   SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY s.order_date) AS rank
   FROM sales AS s
   JOIN members AS m
      ON s.customer_id = m.customer_id
   WHERE s.order_date < m.join_date
)Rr
LEFT JOIN menu AS m2
   ON Rr.product_id = m2.product_id
WHERE Rr.rank = 1;
````



#### Answer:
| customer_id | order_date  | product_name |
| ----------- | ---------- |----------  |
| A           | 2021-01-01 |  sushi        |
| A           | 2021-01-01 |  curry        |
| B           | 2021-01-01 |  curry        |

- Customer A’s last order before becoming a member is sushi and curry.
- Whereas for Customer B, it's Curry.

***

### 8. What is the total items and amount spent for each member before they became a member?

````sql
SELECT s.customer_id, COUNT(DISTINCT s.product_id) AS unique_menu_item, 
   SUM(mm.price) AS total_sales
FROM sales AS s
LEFT JOIN members AS m
   ON s.customer_id = m.customer_id
LEFT JOIN menu AS mm
   ON s.product_id = mm.product_id
WHERE s.order_date < m.join_date
GROUP BY s.customer_id;


````

#### Answer:
| customer_id | unique_menu_item | total_sales |
| ----------- | ---------- |----------  |
| A           | 2 |  25       |
| B           | 2 |  40       |

Before becoming members,
- Customer A spent $ 25 on 2 items.
- Customer B spent $40 on 2 items.

***

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?

````sql
SELECT sales.customer_id, SUM(sales.Points)
FROM 
(
SELECT sl.customer_id,mn.product_name, mn.price, sl.order_date, mb.join_date, 
CASE WHEN product_name = 'sushi' THEN (price * (10*2))
ELSE (Price * 10)
END AS Points
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
LEFT JOIN dbo.members mb ON sl.customer_id = mb.customer_id
--WHERE sl.customer_id = 'C'
--WHERE order_date < join_date
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
)sales
GROUP BY sales.customer_id
ORDER BY sales.customer_id
````


#### Answer:
| customer_id | total_points | 
| ----------- | ---------- |
| A           | 860 |
| B           | 940 |
| C           | 360 |

- Total points for Customer A is 860.
- Total points for Customer B is 940.
- Total points for Customer C is 360.

***

### 10. 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi — how many points do customer A and B have at the end of January?

````sql
SELECT ss.customer_id, SUM(ss.points) AS [Total Points]
FROM
(
SELECT sl.customer_id, mn.product_name, mn.price, sl.order_date, mb.join_date, 
CASE WHEN join_date <= '2021-01-08' THEN (price * (10*2))
WHEN join_date IS NULL THEN NULL
ELSE Price * 10
END AS Points
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
LEFT JOIN dbo.members mb ON sl.customer_id = mb.customer_id
--WHERE sl.customer_id = 'A'
--WHERE order_date < join_date
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
--ORDER BY sl.customer_id, sl.order_date
)ss
GROUP BY ss.customer_id
ORDER BY ss.customer_id
````

#### Answer:
| customer_id | total_points | 
| ----------- | ---------- |
| A           | 1520 |
| B           | 740 |

- Total points for Customer A is 1,520.
- Total points for Customer B is 740.

***

## BONUS QUESTIONS

### Join All The Things - Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)

````sql
SELECT sl.customer_id, mn.product_name, mn.price, sl.order_date, mb.join_date, 
CASE WHEN sl.order_date >= mb.join_date THEN 'Y'
WHEN sl.order_date < mb.join_date THEN 'N'
WHEN mb.join_date IS NULL THEN 'N'
END AS member
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
LEFT JOIN dbo.members mb ON sl.customer_id = mb.customer_id
--WHERE sl.customer_id = 'A'
--WHERE order_date < join_date
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
ORDER BY sl.customer_id, sl.order_date
 ````
 
#### Answer: 
| customer_id | order_date | product_name | price | member |
| ----------- | ---------- | -------------| ----- | ------ |
| A           | 2021-01-01 | sushi        | 10    | N      |
| A           | 2021-01-01 | curry        | 15    | N      |
| A           | 2021-01-07 | curry        | 15    | Y      |
| A           | 2021-01-10 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| B           | 2021-01-01 | curry        | 15    | N      |
| B           | 2021-01-02 | curry        | 15    | N      |
| B           | 2021-01-04 | sushi        | 10    | N      |
| B           | 2021-01-11 | sushi        | 10    | Y      |
| B           | 2021-01-16 | ramen        | 12    | Y      |
| B           | 2021-02-01 | ramen        | 12    | Y      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-07 | ramen        | 12    | N      |

***

### Rank All The Things - Danny also requires further information about the ```ranking``` of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ```ranking``` values for the records when customers are not yet part of the loyalty program.

````sql

SELECT R.* , CASE WHEN R.member = 'Y' THEN RANK() OVER(Partition BY R.customer_id, R.member ORDER BY R.order_date) 
WHEN R.Member = 'N' THEN NULL
END AS ranking
FROM
(
SELECT sl.customer_id, mn.product_name, mn.price, sl.order_date, mb.join_date, 
CASE WHEN sl.order_date >= mb.join_date THEN 'Y'
WHEN sl.order_date < mb.join_date THEN 'N'
WHEN mb.join_date IS NULL THEN 'N'
END AS member
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
LEFT JOIN dbo.members mb ON sl.customer_id = mb.customer_id
--WHERE sl.customer_id = 'A'
--WHERE order_date < join_date
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
--ORDER BY sl.customer_id, sl.order_date
)R
ORDER BY R.customer_id
````

#### Answer: 
| customer_id | order_date | product_name | price | member | ranking | 
| ----------- | ---------- | -------------| ----- | ------ |-------- |
| A           | 2021-01-01 | sushi        | 10    | N      | NULL
| A           | 2021-01-01 | curry        | 15    | N      | NULL
| A           | 2021-01-07 | curry        | 15    | Y      | 1
| A           | 2021-01-10 | ramen        | 12    | Y      | 2
| A           | 2021-01-11 | ramen        | 12    | Y      | 3
| A           | 2021-01-11 | ramen        | 12    | Y      | 3
| B           | 2021-01-01 | curry        | 15    | N      | NULL
| B           | 2021-01-02 | curry        | 15    | N      | NULL
| B           | 2021-01-04 | sushi        | 10    | N      | NULL
| B           | 2021-01-11 | sushi        | 10    | Y      | 1
| B           | 2021-01-16 | ramen        | 12    | Y      | 2
| B           | 2021-02-01 | ramen        | 12    | Y      | 3
| C           | 2021-01-01 | ramen        | 12    | N      | NULL
| C           | 2021-01-01 | ramen        | 12    | N      | NULL
| C           | 2021-01-07 | ramen        | 12    | N      | NULL



***
