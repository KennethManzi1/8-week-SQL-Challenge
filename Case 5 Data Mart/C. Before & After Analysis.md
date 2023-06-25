# Case Study #5 - Data Mart

## Solution - C. Before & After Analysis

### This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time. 

 Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.

 We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before

 Using this analysis approach - answer the following questions:

 1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales
 2. What about the entire 12 weeks before and after?
 3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

We will need both the Weekly Sales CTE and Clean weekly Sales CTE as we will be using both CTEs to help answer the questions

````sql

WITH Weeklysales AS(

SELECT DISTINCT *
FROM dbo.weekly_sales

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales1

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales2

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales3

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales4

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales5

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales6

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales7

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales8

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales9

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales10

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales11

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales12

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales13

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales14

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales15

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales16

UNION 
SELECT DISTINCT *
FROM dbo.weekly_sales17

),

--Clean weekly Sales CTE as we will be using this to help answer the questions
clean_weekly_sales AS(
  SELECT CAST(week_date AS DATE) AS [week_date],
  DATEPART(WEEK, CAST(week_date AS DATE) ) AS [week_number],
  DATEPART(MONTH, CAST(week_date AS DATE) ) AS [Month_number],
  DATEPART(YEAR, CAST(week_date AS DATE) ) AS [Calender_year],
  region,
  platform,
  segment,
  CASE WHEN RIGHT(segment, 1) = '1' THEN 'Young Adults'
  WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
  WHEN RIGHT(segment, 1) = '3' THEN 'Retires'
  ELSE 'Unknown' END AS [Age_band],
  CASE WHEN LEFT(segment, 1 ) = 'C' THEN 'Couples'
  WHEN LEFT(segment, 1 ) = 'F' THEN 'Families'
  ELSE 'Unknown' END AS [Demographic],
  transactions,
  ROUND(CAST(Sales AS float)/transactions, 2) AS [Avg_transactions],
  sales
  FROM weeklysales

)



````


***

### 1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?

We first need to get the week_number for the date 2020-06-15 so that we can come up with the ranges for the before 2020-06-15 and after 2020-06-15

````sql
SELECT DISTINCT week_number 
FROM clean_weekly_sales 
WHERE week_date = '2020-06-15'

````
![Screen Shot 2023-06-24 at 11 06 15 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/f6fe2331-f0b4-4e8c-98e1-66ee28824c15)

From this query we can see that the weekdate falls under week 25.



So now we can create a CTE for the total sales filtered four weeks before week 25 and four weeks after week 25.

````sql
tsales4 AS(
SELECT week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 21 and 28) and Calender_year = '2020'
GROUP BY week_date, week_number
),

````
Then we will create a CTE for both before and after week 25 sales

````sql
before_after_sales4 AS(
    SELECT 
    SUM(CASE WHEN week_number BETWEEN 21 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 28 THEN [Total Sales] END) AS [After Sales]
    FROM tsales4
)

SELECT [Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales4


````

**Answer:**
![Screen Shot 2023-06-24 at 11 39 41 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/79d7a5c0-0230-42e6-9075-f87639d1c7c7)


Here we can see that there was a decline of sales four weeks after week 25 which was at a 1.15% decline in the year 2020


***

### 2. What about the entire 12 weeks before and after?

We will do the same thing as part 1 except now we will go 12 weeks before week 25 and 12 weeks after week 25 instead of 4 weeks before/after

So now we can create a CTE for the total sales filtered twelve weeks before week 25 and twelve weeks after week 25.

````sql
tsales12 AS(
SELECT week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 13 and 37)
GROUP BY week_date, week_number
),
````

Then we will create a CTE for both before and after week 25 sales

````sql

before_after_sales12 AS(
    SELECT 
    SUM(CASE WHEN week_number BETWEEN 13 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 37 THEN [Total Sales] END) AS [After Sales]
    FROM tsales12
)

SELECT [Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales12

````

**Answer:**

![Screen Shot 2023-06-24 at 11 37 43 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/e2b5a537-41ff-477e-b6df-f7554e709375)

Here we can see that there was a decline of sales twelve weeks after week 25 which was at a 2.14% decline in the year 2020


***

### 3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

We will use the week 4 and week 12 CTEs that we created for parts 1 and 2 to grab the Sales time differences and the Growth and Decline in Sales for both 2018 and 2019

We will Start the 4 week time periods with the year of 2018


````sql

tsales42018 AS(
SELECT Calender_year, week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 21 and 28) and Calender_year = '2018'
GROUP BY Calender_year, week_date, week_number
),


before_after_sales42018 AS(
    SELECT Calender_year,
    SUM(CASE WHEN week_number BETWEEN 21 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 28 THEN [Total Sales] END) AS [After Sales]
    FROM tsales42018
    GROUP BY Calender_year
)

SELECT [Calender_year], [Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales42018

````
![Screen Shot 2023-06-24 at 11 48 57 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/d634776b-bf85-47c1-abd2-b6f86ccaac45)

Here we can see that there was a growth of sales at 0.19% on 2018 and this can be seen with a difference of $4,102,105


For the 2018 Week 12 Time Periods

````sql

tsales122018 AS(
SELECT Calender_year, week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 13 and 37) and Calender_year = '2018'
GROUP BY Calender_year, week_date, week_number
),


before_after_sales122018 AS(
    SELECT Calender_year,
    SUM(CASE WHEN week_number BETWEEN 13 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 37 THEN [Total Sales] END) AS [After Sales]
    FROM tsales122018
    GROUP BY Calender_year
)

SELECT [Calender_year], [Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales122018

````


![Screen Shot 2023-06-24 at 11 53 03 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/7460c7e4-0dcf-4d3d-99f5-7baac6425ec5)

Here we can see that there was a growth of sales at 1.63% on 2018 and this can be seen with a difference of $104,256,193



Next is the 4 week time periods with the year of 2019

````sql

tsales42019 AS(
SELECT Calender_year, week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 21 and 28) and Calender_year = '2019'
GROUP BY Calender_year, week_date, week_number
),


before_after_sales42019 AS(
    SELECT Calender_year,
    SUM(CASE WHEN week_number BETWEEN 21 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 28 THEN [Total Sales] END) AS [After Sales]
    FROM tsales42019
    GROUP BY Calender_year
)

SELECT [Calender_year], [Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales42019

````

![Screen Shot 2023-06-25 at 12 03 12 AM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/3c01b11f-cd87-42ea-babc-9503ad7eb432)


Here we can see that there was a growth of sales at 0.1% on 2019 and this can be seen with a difference of $2,336,594



--For the 2019 Week 12 Time Periods

````sql


tsales122019 AS(
SELECT Calender_year, week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 13 and 37) and Calender_year = '2019'
GROUP BY Calender_year, week_date, week_number
),


before_after_sales122019 AS(
    SELECT Calender_year,
    SUM(CASE WHEN week_number BETWEEN 13 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 37 THEN [Total Sales] END) AS [After Sales]
    FROM tsales122019
    GROUP BY Calender_year
)

SELECT [Calender_year], [Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales122019
````

![Screen Shot 2023-06-25 at 12 08 03 AM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/3776e26c-96e6-43e1-980f-1de8eaaaab52)

Here we can see that there was a decline of sales which was at a 0.3% decline on 2019 and this can be seen with a difference of -$20,740,294.

This means that the sales drastically dropped 12 weeks after week 25 on 2019.




Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%205%20Data%20Mart/D.%20Bonus%20Question.md)
for solution for D. Bonus Question

