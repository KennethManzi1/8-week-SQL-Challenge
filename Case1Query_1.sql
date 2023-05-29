--Creating the Danny's Diner Database

USE master;
GO

IF NOT EXISTS (
      SELECT name
      FROM sys.databases
      WHERE name = N'TutorialDB'
      )
   CREATE DATABASE [Dannys_Dinner];
GO

IF SERVERPROPERTY('ProductVersion') > '12'
   ALTER DATABASE [Dannys_Dinner] SET QUERY_STORE = ON;
GO

---Creating Sales table

CREATE TABLE dbo.sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

--Inserting Sales data
INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');

--Creating the Menu Table
CREATE TABLE dbo.menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);
--Inserting Menu Data
INSERT INTO dbo.menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
--Creating Members Table
CREATE TABLE dbo.members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);
--Inserting members data
INSERT INTO dbo.members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

  /*Case Study 1 questions

1. What is the total amount each customer spent at the restaurant? 
            Customer A spent total of 76 dollars.
            Customer B spent total of 74 dollars.
            Customer C spent total of 36 dollars.

2. How many days has each customer visited the restaurant?
     Customer A: 4 days
     Customer B: 6 days
     Customer C: 2 days


3. What was the first item from the menu purchased by each customer?
    Customer A: Sushi
    Customer B: Curry
    Customer C: Ramen


4. What is the most purchased item on the menu and how many times was it purchased by all customers?
        Ramen and it was purchased 8 times by all customers

5. Which item was the most popular for each customer?
     Customer A: Ramen
     Customer B: All 3 
     Customer C: Ramen

6. Which item was purchased first by the customer after they became a member?
    Customer A: Ramen
    Customer B: Sushi and Ramen
    Customer C: None
  
7. Which item was purchased just before the customer became a member?
   Customer A: Sushi and Curry
   Customer B: Curry and Sushi
   Customer C: Ramen
8. What is the total items and amount spent for each member before they became a member?
    Customer A: 2 items and total amount of 25 dollars
    Customer B: 3 items and total amount of 40 dollars
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
   Customer A has a total of 860 points
   Customer B has a total of 940 points
   Customer C has a total of 360 points
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
    Customer A has a total of 1520 points
    Customer B has a total of 940 points
*/
--SQL Queries to answer the Case study questions
SELECT sl.customer_id, mn.product_name, mn.price, sl.order_date, mb.join_date, 
CASE WHEN product_name = 'sushi' THEN (price * (10*2))
ELSE (Price * 10)
END AS Points
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
LEFT JOIN dbo.members mb ON sl.customer_id = mb.customer_id
--WHERE sl.customer_id = 'C'
--WHERE order_date < join_date
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
ORDER BY sl.customer_id, sl.order_date

--Customer A total Amount
SELECT SUM(mn.price)
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
WHERE sl.customer_id = 'A'
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
--ORDER BY sl.customer_id, mn.product_id

--Customer B total Amount
SELECT SUM(mn.price)
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
WHERE sl.customer_id = 'B'
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
--ORDER BY sl.customer_id, mn.product_id

--Customer C total Amount
SELECT SUM(mn.price)
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
WHERE sl.customer_id = 'C'
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
--ORDER BY sl.customer_id, mn.product_id


--Customer A total Amount
SELECT SUM(mn.price)
FROM dbo.sales AS sl
LEFT JOIN dbo.menu AS mn ON sl.product_id = mn.product_id
WHERE sl.customer_id = 'A'
--GROUP BY sl.customer_id, mn.product_name, mn.price, sl.order_date, mn.product_id
--ORDER BY sl.customer_id, mn.product_id

--Question 10 SQL query
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
ORDER BY sl.customer_id, sl.order_date

--BONUS:  Determining Whether the customer is a Member 
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

--Bonus: Ranking the members

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