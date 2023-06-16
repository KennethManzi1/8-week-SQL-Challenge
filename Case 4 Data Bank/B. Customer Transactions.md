# Case Study #4 - Data Mart

## Solution - B. Customer Transactions

Because the dataset was way over 1000 rows, I had to split the customer transactions data into 6 tables and UNION ALL them in a CTE to create the customer nodes table

### 1. What is the unique count and total amount for each transaction type?

````sql
WITH Customer_Transactions AS
(
    SELECT *
FROM dbo.customer_transactions1
UNION ALL

SELECT *
FROM dbo.customer_transactions2
UNION ALL

SELECT *
FROM dbo.customer_transactions3
UNION ALL

SELECT *
FROM dbo.customer_transactions4
UNION ALL

SELECT *
FROM dbo.customer_transactions5
UNION ALL

SELECT *
FROM dbo.customer_transactions6

)

SELECT txn_type, SUM(txn_amount) AS [Total Amount], COUNT(*) AS [Unique Type]
FROM Customer_Transactions
GROUP BY txn_type
ORDER BY txn_type
````

**Answer:**

![Screen Shot 2023-06-16 at 5 47 24 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/479cc365-00ca-4d6a-b477-4c87c02a78ed)


There were lots of deposits at 1,359,168, followed by purchases at 806,537 and then withdrawals at 793,003.


### 2. What is the average total historical deposit counts and amounts for all customers?
````sql
WITH Customer_Transactions AS
(
    SELECT *
FROM dbo.customer_transactions1
UNION ALL

SELECT *
FROM dbo.customer_transactions2
UNION ALL

SELECT *
FROM dbo.customer_transactions3
UNION ALL

SELECT *
FROM dbo.customer_transactions4
UNION ALL

SELECT *
FROM dbo.customer_transactions5
UNION ALL

SELECT *
FROM dbo.customer_transactions6

)



SELECT dep.txn_type, AVG(dep.[Number of Deposits]) AS [Average Number of Deposits], AVG(dep.[Deposit Amount]) AS [Average deposit amount]
FROM
(
SELECT customer_id, txn_type, COUNT(customer_id) AS [Number of Deposits], AVG(txn_amount) AS [Deposit Amount]
FROM Customer_Transactions
WHERE txn_type = 'deposit'
GROUP BY customer_id, txn_type
)dep
GROUP BY dep.txn_type
````

**Answer:**

Average historical number of Deposits is 5 and Average Deposit Amount is 508



***Click [here]

for solution for C. Data Allocation Challenge

