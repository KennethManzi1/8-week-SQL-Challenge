# Case Study #4 - Data Mart

## Solution - B. Customer Transactions

Because the dataset was way over 1000 rows, I had to split the customer transactions data into 6 tables and UNION ALL them in a CTE to create the customer nodes table

### 1. What is the unique count and total amount for each transaction type?

We will first create the CTE for the Customer Transactions data as the dataset is too large

We use count to find the unique transaction types numbers and SUM to calculate the total amounts.

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

We will first create the CTE for the Customer Transactions data as the dataset is too large

We create a subquery to find the total deposits and amounts for each customer.

Then we calculate the average total deposists and total amounts for all customers on the main outer query.

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

### 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

We will first create the CTE for the Customer Transactions data as the dataset is too large

Then  we create a subquery to pull the number of deposits, purchases and, and number of withdrawals for each month and you can see that We are using the Date Part functions to get the month and date name to get the name of the month

After that we use the outer main query to pull the unique number of customers per month


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

SELECT transact.Month, transact.[Month Name], COUNT(DISTINCT transact.customer_id) AS [Number of Customers]
FROM
(
SELECT customer_id, DATEPART(MONTH, txn_date) AS [Month], DATENAME(MONTH, txn_date) AS [Month Name],
 SUM(CASE WHEN txn_type = 'deposit' THEN 0 ELSE 1 END) AS [Number of Deposits],
SUM(CASE WHEN txn_type = 'purchase' THEN 0 ELSE 1 END) AS [Number of purchases],
SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS [Number of Withdrawals]
FROM Customer_Transactions
GROUP BY customer_id, DATEPART(Month, txn_date), DATENAME(MONTH, txn_date)
)transact
WHERE transact.[Number of Deposits] > 1 AND (transact.[Number of purchases] >=1 OR transact.[Number of Withdrawals] >=1)
GROUP BY transact.month, transact.[Month Name]
ORDER BY transact.month
````


**Answer:**

![Screen Shot 2023-06-16 at 5 54 08 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/4cc12a48-96b3-43ee-875d-73717080b067)

### 4. What is the closing balance for each customer at the end of the month?



***Click [here]

for solution for C. Data Allocation Challenge

