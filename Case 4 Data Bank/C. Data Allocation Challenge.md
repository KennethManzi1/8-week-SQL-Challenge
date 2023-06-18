# Case Study #4  - Data Bank

## Solution - C. Data Allocation Challenge

### 1. To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:



### Option 1: data is allocated based off the amount of money at the end of the previous month
### Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
### Option 3: data is updated real-time
### For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:

### running customer balance column that includes the impact each transaction
### customer balance at the end of each month
### minimum, average and maximum values of the running balance for each customer
### Using all of the data available - how much data would have been required for each option on a monthly basis?



***


We will first create the CTE for the Customer Transactions data as the dataset is too large

Then we will first create a query that gets running customer balance column that includes the impact each transaction.

We will be using SUM() Over() to get the running total balance of each customer and assigning negative values for withdrawals and purchases.

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


SELECT customer_id, DATEPART(MONTH, txn_date) AS [Month], DATENAME(MONTH, txn_date) AS [Name of the Month],
SUM(
CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END) AS [Closing Customer Balance]
FROM Customer_Transactions
GROUP BY customer_id,  DATEPART(MONTH, txn_date),  DATENAME(MONTH, txn_date)
````


**Answer:**


![Screen Shot 2023-06-17 at 9 50 23 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/0759b213-115e-4e76-8d25-890183893ed1)

***

Next thing we will need to do is to get customer balance at the end of each month.

Again since we need the customer transaction data, we will need the CTE again to write the query to get the customer closing balance

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


SELECT customer_id, DATEPART(MONTH, txn_date) AS [Month], DATENAME(MONTH, txn_date) AS [Name of the Month],
SUM(
CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END) AS [Closing Customer Balance]
FROM Customer_Transactions
GROUP BY customer_id,  DATEPART(MONTH, txn_date),  DATENAME(MONTH, txn_date)

````

**Answer:**

![Screen Shot 2023-06-17 at 9 55 33 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/3bce184e-5d26-4b5a-ad5f-204e4cb7c262)


***Click [here]

for solution for D.  Extra Challenge

