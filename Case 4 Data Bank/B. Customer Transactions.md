# Case Study #4 - Data Mart

## Solution - B. Customer Transactions

Because the dataset was way over 1000 rows, I had to split the customer transactions data into 6 tables and UNION ALL them in a CTE called Customer_Transactions to create the customer Transactions table

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
We will first create the CTE for the Customer Transactions data as the dataset is too large

Then we use a subquery to aggregate the customer transactions by the customer and the month they made the transaction

Within the subquery, we will use the date add function to truncate the date column to have it start at the beginning of the month so that we can group the transactions by month.

Then we will use sum to get the total transactions and within that we will distinguish the deposits and the withdrawals with a case statement. Lastly we will use the main outer query to pull the closing balance based on the month

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

),


month_transaction AS(
    SELECT customer_id, DATEADD(MONTH, DATEDIFF(MONTH, 0, txn_date), 0) AS [Start of the month],
    SUM(CASE WHEN txn_type = 'Deposit' THEN txn_amount ELSE -txn_amount END) AS total_amount
    FROM customer_transactions
    GROUP By customer_id, txn_amount, txn_type, DATEADD(MONTH, DATEDIFF(MONTH, 0, txn_date), 0) 

);

SELECT customer_id, DATEPART(MONTH, [Start of the month]) AS MONTH, DATENAME(MONTH, [Start of the month]) AS [Name of the month],
 SUM(total_amount) AS [Closing Balance]
FROM month_transaction
GROUP BY customer_id, DATEPART(MONTH, [Start of the month]),  DATENAME(MONTH, [Start of the month])

````
**Answer:**


![Screen Shot 2023-06-17 at 8 32 26 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/6f81b8e2-7c5a-4d67-a742-2e87136cf2f1)


### 5. What is the percentage of customers who increase their closing balance by more than 5%?

We will first create the CTE for the Customer Transactions data as the dataset is too large


Then we will create a CTE to calculate the total transactions towards the end of the month

Afterwords we will create a CTE to calculate the closing balance of each customer per month and the percentage increase in the closing balance for each customer.

Finally our main outer query will calculate the percentage of customers whose closing balance increased 5% compared to the previous month


````SQL

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

),

Monthly_transactions AS
(
    SELECT customer_id, EOMONTH(txn_date) AS end_date,
    SUM(CASE WHEN txn_type = 'Deposit' THEN txn_amount ELSE -txn_amount END) AS total_amount
    FROM customer_transactions
    GROUP BY customer_id, EOMONTH(txn_date)
),

EOMclosingbalancepct AS(

SELECT pct.customer_id, pct.end_date, pct.[Closing Balance], COALESCE(LAG(pct.[Closing Balance]) OVER(PARTITION BY customer_id ORDER BY end_date),0) AS [Previous Closing Balance],
COALESCE(100 * (pct.[Closing Balance] - LAG(pct.[Closing Balance]) OVER (PARTITION BY customer_id ORDER BY end_date))/ COALESCE(LAG(pct.[Closing Balance]) OVER(PARTITION BY customer_id ORDER BY end_date),0),0) AS [Percent Increase]
FROM
(
SELECT customer_id, end_date,
 SUM(total_amount) AS [Closing Balance]
FROM Monthly_transactions
GROUP BY customer_id, end_date
)pct
)

SELECT CAST(100.0 * COUNT(DISTINCT pc.customer_id) / (SELECT COUNT(DISTINCT customer_id) FROM customer_transactions) AS FLOAT) AS pct_customers
FROM EOMclosingbalancepct AS pc
--INNER JOIN customer_transactions AS ct ON pc.customer_id = ct.customer_id
WHERE [Percent Increase] > 5;

````
**Answer:**


53.8 percent of the customers had their closing balance increase by 5% compared to the previous month.


***Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%204%20Data%20Bank/C.%20Data%20Allocation%20Challenge.md) for solution for C. Data Allocation Challenge

