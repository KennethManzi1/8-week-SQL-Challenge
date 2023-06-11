# Case Study #3 - Foodie-Fi

## Solution - C. Challenge Payment Question

### 1. The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
once a customer churns they will no longer make payments


**Steps:**

--First thing we need to do is to create the payments table. The table will store the payment data for the year 2020 and has several columns such as payment id, customer id plan id, the plan name, the date of the payment, the order and the amount.

````sql
SELECT COUNT(*) AS pizza_order_count
FROM dbo.customer_orders
````

**Answer:**




***Click [here] for solution for B. Runner and Customer Experience!

