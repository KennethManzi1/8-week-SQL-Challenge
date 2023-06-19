# Case Study #4 -  Data Bank

## Solution - D. Extra Challenge

### Data Bank wants to try another option which is a bit more difficult to implement - they want to calculate data growth using an interest calculation, just like in a traditional savings account you might have with a bank.

### If the annual interest rate is set at 6% and the Data Bank team wants to reward its customers by increasing their data allocation based off the interest calculated on a daily basis at the end of each day, how much data would be required for this option on a monthly basis?

### Special notes: Data Bank wants an initial calculation which does not allow for compounding interest, however they may also be interested in a daily compounding interest calculation so you can try to perform this calculation if you have the stamina!


We will first create the CTE for the Customer Transactions data as the dataset is too large

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
````

We will now create a CTE to calculate the daily interest rate for each customer within each month at the start.

Within the CTE we will use this daily interest formula: P*(1+r/n)^n*t, where P is the total data used by the customer up to the transaction date, r is the annual interest rate (^%), n is the number of days in a year (365), and t is the number of days between January 1, 1900, and the transaction date. 

The POWER function is used to calculate (1+r/n)^n, and the DATEDIFF function is used to calculate t.

We will also calculate the date difference between the transaction date and the first day of the month. To get the first day of month we will use DATEFROMPARTS

````sql

daily_interest AS(
    SELECT customer_id, SUM(txn_amount) AS [Total Data],
    txn_date, DATEFROMPARTS(YEAR(txn_date), MONTH(txn_date), 1) AS [Start Date of The Month],
    DATEDIFF(DAY,DATEFROMPARTS(YEAR(txn_date), MONTH(txn_date), 1), txn_date ) AS [Difference of days in month],
    SUM(txn_amount) * POWER((1 + 0.06/365), DATEDIFF(DAY, '1900-01-01', txn_date)) AS [Daily Interest Data]
    FROM Customer_Transactions
    GROUP BY customer_id, txn_date
)

SELECT customer_id, DATEFROMPARTS(YEAR([Start Date of The Month]), MONTH([Start Date of The Month]), 1) AS [First day of month], [Difference of days in month], [Daily Interest Data],
ROUND(SUM([Daily Interest Data] * [Difference of days in month]), 2) AS [Data Required]
FROM daily_interest
GROUP BY customer_id, DATEFROMPARTS(YEAR([Start Date of The Month]), MONTH([Start Date of The Month]), 1), [Difference of days in month], [Daily Interest Data]
ORDER BY [Data Required]
````
