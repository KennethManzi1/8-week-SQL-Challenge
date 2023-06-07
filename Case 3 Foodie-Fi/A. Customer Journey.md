# Case Study #3 - Foodie-Fi

## Solution - A. Customer Journey

### 1. Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

````sql
---A Customer Journey Query

SELECT subs.customer_id, pn.plan_id, pn.plan_name, subs.start_date, LAG(subs.start_date) OVER(ORDER BY customer_id) AS [Previous Start Date],
DATEDIFF(day, LAG(subs.start_date) OVER (PARTITION BY customer_id ORDER BY subs.start_date),subs.start_date ) AS [Difference between Current Date and Previous Date]
FROM dbo.subscriptions AS subs 
FULL JOIN dbo.plans AS pn ON subs.plan_id = pn.plan_id
WHERE subs.customer_id < 11

````


**Answer:**

- Customer 1 signed up for a free trial on the 1st of August 2020 and decided to subscribe to the basic monthly plan on August 8th 2020 right after it ended.
- Customer 2 signed up for a free trial on the 20th of September 2020 and decided to upgrade to the pro annual plan on September 27th 2020 right after it ended.
- Customer 3 signed up for a free trial on the 13th of January 2020 and decided to upgrade to the basic monthly plan on the 20th of January 2020 right after it ended.
- Customer 4 signed up for a free trial on the 17th of Janaury 2020, subscribed to the basic monthly on the 24th of January 2020.
- Customer 5 signed up for a free trial on the 3rd of August 2020 and subscribed to the basic monthly on the 10th of August 2020 after it ended.
- Customer 6 signed up for a free trial on the 23rd of December 2020 and subscribed to the basic monthly plan on the 30th of December 2020.
- Customer 7 signed up for a free trial on the 5th of February 2020, subscribed to the basic monthly plan on the 12th of February 2020, and upgraded to the pro monthly plan 3 months later.
- Customer 8 signed up for a free trial on the 11th of June 2020, subscribed to the basic monthly plan on the 18th of February 2020, and upgraded to the pro monthly plan 2 months later.
- Customer 9 signed up for a free trial on the 07th of December 2020 and upgraded to the pro annual on the 14th of December 2020.
- Customer 10 signed up for a free trial on the 19th of September 2020 and upgraded to the pro annual on the 26th of September 2020.

![Screen Shot 2023-06-05 at 3 32 06 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/0e4085a7-e01e-4458-a975-48ce6f0f0d7f)




***Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%203%20Foodie-Fi/B.%20Data%20Analysis%20Questions.md) for solution for B. Data Analysis Questions

