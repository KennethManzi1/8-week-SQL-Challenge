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


SELECT customer_id, txn_date, txn_type, txn_amount, 
SUM(
CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END)
OVER(PARTITION BY customer_id ORDER BY txn_date) AS [Running Balance]
FROM Customer_Transactions
````


**Answer:**


![Screen Shot 2023-06-17 at 9 50 23 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/0759b213-115e-4e76-8d25-890183893ed1)

***

Next thing we will need to do is to get customer balance at the end of each month.

Again since we need the customer transaction data, we will need the Customer Transactions CTE again to write the query to get the customer closing balance

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



***

Finally we will need to get minimum, average and maximum values of the running balance for each customer.

We will use the Customer Transactions CTE to get our customer transactions data

Then we will use the Running Balance query we created earlier as a subquery to pull the minimum, average, maximum values of the running balance in the main query


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

SELECT Rb.customer_id, MIN(Rb.[Running Balance]) AS [Minimum Running Balance], MAX(Rb.[Running Balance]) AS [Maximum Running Balance], AVG(Rb.[Running Balance]) AS [Average Running Balance]
FROM
(
SELECT customer_id, txn_date, txn_type, txn_amount, 
SUM(
CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE -txn_amount END)
OVER(PARTITION BY customer_id ORDER BY txn_date) AS [Running Balance]
FROM Customer_Transactions
)Rb
GROUP BY Rb.customer_id

````
![Screen Shot 2023-06-17 at 9 59 56 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/1666f6d0-15d3-42e2-9a4e-727f3a46f7d2)


***

### Option 1: data is allocated based off the amount of money at the end of the previous month
### How much data would have been required on a monthly basis?

We will first create the CTE for the Customer Transactions data as the dataset is too large
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
````

We will then create the CTE to get the total monthly transactions for each customer for each month. This CTE is the Monthly_transactions CTE.

After that we will create the CTE to get the running balance and later calculate the month end balance for each customer. That CTE is called the RBalance CTE.

Lastly with the data gathered, we will create a query to calculate the data required per month by finding the total monthly ending balances for each customer.

````SQL

Monthly_transactions AS
(
    SELECT customer_id, txn_date, DATEPART(MONTH, txn_date) AS [Month of transaction], DATENAME(MONTH, txn_date) AS [Month Name], txn_type,
    SUM(CASE WHEN txn_type = 'Deposit' THEN txn_amount ELSE -txn_amount END) AS total_amount
    FROM customer_transactions
    GROUP BY customer_id, txn_date, txn_type
),

RBalance AS
(
SELECT Running_Balance.customer_id, Running_Balance.[Month of transaction], Running_Balance.[Month Name], MAX(Running_Balance.[Running Balance]) AS [Month End Balance]
FROM
(
SELECT customer_id, txn_date, [Month of transaction], [Month Name], [total_amount], 
SUM([total_amount]) OVER(PARTITION BY customer_id ORDER BY txn_date) AS [Running Balance]
FROM Monthly_transactions
)Running_Balance
GROUP BY  Running_Balance.customer_id, Running_Balance.[Month of transaction], [Month Name]
)

SELECT [Month of transaction], [Month Name], SUM([Month End Balance]) AS [Data Allocated]
FROM RBalance
GROUP BY [Month of transaction], [Month Name]
ORDER BY [Data Allocated] DESC;
````


**Answer:**

![Screen Shot 2023-06-18 at 1 30 56 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/0ffb9f8e-6bc5-4ad6-be16-49496b2b3374)

January requires more monthly data allocation at 351,521 while February requires a data allocation at 230473 and March at 109155. April thad the least requirement of data allocation at -78991.

This means that the data that is required to allocate per month varies depending on the month and the transaction activities of the customers.

This insight suggests that the amount of data required by customers is directly related to their transaction activities, and specifically to their end-of-month balances. 

Furthermore, this means that that customers with higher balances tend to require more data than those with lower balances. Ex with the January month since it has higher data allocation, this means that the customers require more data for the month of January.

This will definitely help to predict customer behaviour which in turn will help to optimizing business strategies and managing costs.

***

### Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days

We will first create the CTE for the Customer Transactions data as the dataset is too large

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
````


We will create the CTE to get the total monthly transactions for each customer for each month. This CTE is the monthly transactions CTE

Next we will create the CTE to get the running balance and later calculate the average running customer balance per customer for each month. 
This CTE is called the Rbalance CTE

Lastly with the data gathered, we will create a query to calculate the data required per month by finding the total monthly average balances for each customer.


````SQL

Monthly_transactions AS
(
    SELECT customer_id, txn_date, DATEPART(MONTH, txn_date) AS [Month of transaction], DATENAME(MONTH, txn_date) AS [Month Name], txn_type,
    SUM(CASE WHEN txn_type = 'Deposit' THEN txn_amount ELSE -txn_amount END) AS total_amount
    FROM customer_transactions
    GROUP BY customer_id, txn_date, DATEPART(MONTH, txn_date), DATENAME(MONTH, txn_date), txn_type
),



RBalance AS
(
SELECT Running_Balance.customer_id, Running_Balance.[Month of transaction], Running_Balance.[Month Name], AVG(Running_Balance.[Running Balance]) AS [AVG Running Balance]
FROM
(
SELECT customer_id, txn_date, [Month of transaction], [Month Name], [total_amount], 
SUM([total_amount]) OVER(PARTITION BY customer_id ORDER BY txn_date) AS [Running Balance]
FROM Monthly_transactions
)Running_Balance
GROUP BY  Running_Balance.customer_id, Running_Balance.[Month of transaction], [Month Name]
)


SELECT [Month of transaction], [Month Name], SUM([AVG Running Balance]) AS [Data Required Per Month]
FROM RBalance
GROUP BY [Month of transaction], [Month Name]
ORDER BY [Data Required Per Month] DESC;

````

**Answer:**

![Screen Shot 2023-06-18 at 10 18 12 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/01bee42e-5f54-435b-aa3f-c15f1ae1801f)

Based on the query output, the average running customer balance is negative for January and February. Therefore during these months, the customers are depositing more money than they're using
However this is the opposite for March and April as we can see that the customers are taking more money out than they're putting in.

The negative balances for March and April could affect the bank's financial health. Therefore the bank should collect more data especially for April to better understand customer behavior and identify 
anamolies that may affect the bank. In addition to collecting data on the negative balance. 

The bank should also collect more data for the positive balance especially for January so that the bank can collect
insights that could help them improve their business.

***

### Option 3: data is updated real-time

We will first create the CTE for the Customer Transactions data as the dataset is too large

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
````

We then will create the CTE to get the total monthly transactions for each customer for each month.

Next we will create the CTE to get the running balance of each month by calculating the running totals of the transactions using the SUM() OVER() clause.

Lastly with the data gathered, we will create a query to calculate the data in real-time.


````SQL
Monthly_transactions AS
(
    SELECT customer_id, txn_date, DATEPART(MONTH, txn_date) AS [Month of transaction], DATENAME(MONTH, txn_date) AS [Month Name], txn_type, txn_amount,
    SUM(CASE WHEN txn_type = 'Deposit' THEN txn_amount ELSE -txn_amount END) AS total_amount
    FROM customer_transactions
    GROUP BY customer_id, txn_date, DATEPART(MONTH, txn_date), DATENAME(MONTH, txn_date), txn_type, txn_amount
),

RBalance AS
(

SELECT customer_id, [Month of transaction], [Month Name], [total_amount], 
SUM([total_amount]) OVER(PARTITION BY customer_id ORDER BY txn_date) AS [Running Balance]
FROM Monthly_transactions

)


SELECT [Month of transaction], [Month Name], SUM([Running Balance]) AS [Data Required Per Month]
FROM RBalance
GROUP BY [Month of transaction], [Month Name]
ORDER BY [Data Required Per Month] DESC;

````

![Screen Shot 2023-06-18 at 10 24 44 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/572369eb-f077-4378-b6ea-787f34515dcb)


The data required for the month of March is significantly higher than for the other months. This shows that there were more transactions happening in March than in the other months. 

April too also had a high data requirement which means there were also alot of data transactions happening in that month as well.

The data required for January and February are positive, indicating that there might be some customers who have a higher balance at the beginning of the year.



***Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%204%20Data%20Bank/D.%20Extra%20Challenge.md)
for solution for D.  Extra Challenge

