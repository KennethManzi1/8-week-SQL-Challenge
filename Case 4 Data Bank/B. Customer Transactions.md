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

There were lots of deposits at 1,359,168, followed by purchases at 806,537 and then withdrawals at 793,003.


***Click [here]

for solution for C. Data Allocation Challenge

