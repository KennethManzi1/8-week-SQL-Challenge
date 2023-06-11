# Case Study #3 - Foodie-Fi

## Solution - C. Challenge Payment Question

### 1. The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
once a customer churns they will no longer make payments


**Steps:**

- First thing we need to do is to create the payments table. The table will store the payment data for the year 2020 and has several columns such as payment id, customer id plan id, the plan name, the date of the payment, the order and the amount.

````sql
DROP TABLE IF EXISTS dbo.payments2020 
CREATE TABLE dbo.payments2020(
  payment_id INT IDENTITY(1, 1) PRIMARY KEY,
  customer_id INT NOT NULL,
  plan_id INT NOT NULL,
  plan_name VARCHAR(50) NOT NULL,
  payment_date DATE NOT NULL,
  Payment_order INT NOT NULL,
  amount FLOAT 
);
````
- Next is to pull the data from the subscriptions and and plans tables into the payments_2020 table through A CTE or a FROM subquery.
- Both methods will create a virtual table that will pull fields of customer and plan ids, plan names, the payment date and amount along with the start and next dates with the records.
- After that, you'll need a column where we make sure that we are only pulling in 2020 dates. I'll do this by create a case statement from a subquery and filtering out the trial and churn plans. Also need to take care of the Nulls in Amount as well with another Case Statement.
- Once we take care of the start and Next dates for the customers starting their free trials to upgrading to new plans and cleaning up Null filtering out post 2020 next dates with december 31st 2020 as a cap to the 2020 year, We will now proceed to add a new column named Modified Next Date which contains the date that is one month before the next_date column.
- With the vt CTE ready with the required data. We will create a new CTE in order  to perform a recursive function where we will generate payment dates for each customer and create a plan based on their starrt date, end date, and next date.
- Similar to how Python, C++ and Java recursion, the function will keep running recursively until the date of the payment is equal or after the next date at which the logic stops.

````sql
WITH vt AS(

SELECT modifiednextdate.*, DATEADD(MONTH, -1, modifiednextdate.Next_Date) AS [Modified Next Date]
FROM
(
SELECT ch.customer_id, ch.plan_id, ch.plan_name, ch.payment_date, CASE WHEN ch.Amount IS NULL THEN 0 ELSE ch.Amount END AS [Amount], ch.[Start Date],
CASE WHEN ch.[Next Date] IS NULL OR ch.[Next Date] > '2020-12-31' THEN '2020-12-31' ELSE ch.[Next Date] END AS [Next_Date]
FROM
(
SELECT subs.customer_id, subs.plan_id, pn.plan_name, subs.start_date AS payment_date, pn.price AS [Amount], subs.start_date AS [Start Date],
LEAD(subs.start_date, 1) OVER(PARTITION BY subs.customer_id ORDER BY subs.start_date, subs.plan_id) AS [Next Date]
FROM dbo.subscriptions AS subs 
LEFT JOIN plans as pn 
ON subs.plan_id = pn.plan_id
)ch
)modifiednextdate
),



RecursionDate AS(
    SELECT customer_id, plan_id, plan_name, Amount, [Start Date],   
    payment_date = (SELECT TOP 1 [Start Date] FROM vt WHERE customer_id = customer_id AND plan_id = plan_id),
    [Next_Date], [Modified Next Date]
    FROM vt 

    UNION ALL
    SELECT customer_id, plan_id, plan_name, Amount, [Start Date], DATEADD(MONTH, 1, payment_date) AS [payment_date],
    Next_Date, [Modified Next Date]
    FROM RecursionDate
    WHERE payment_date < [Modified Next Date] AND plan_name != 'pro annual'
)

````

- Testing out the vt virtual table to make sure it works
````sql
SELECT * 
FROM vt 

````


- Testing out the Recursion Date CTE to make sure it works

````sql
SELECT *
FROM RecursionDate

````
**Answer:**




***Click [here] for solution for B. Runner and Customer Experience!

