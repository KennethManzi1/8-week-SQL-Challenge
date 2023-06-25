# Case Study #5 - Data Mart

## Solution - B. Data Exploration

We will need both the Weekly Sales CTE and Clean weekly Sales CTE as we will be using both CTEs  to help answer the questions


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

### 1. What day of the week is used for each week_date value?


````sql
SELECT DISTINCT  week_date, DATENAME(WEEKDAY, week_date) AS [Week_day]
FROM clean_weekly_sales
````

**Answer:**

![Screen Shot 2023-06-24 at 9 48 26 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/714a5c26-8b0f-48df-897d-526beab3a369)

Here we use the DATENAME() date function to get the name of the week day in this case it is Monday


## 2. What range of week numbers are missing from the dataset?

To solve this problem, we can create CTE for the range of the week numbers where we call the CTE within itself using Recursion to get the week numbers that are missing


````sql
WITH missing_weeknum AS(
SELECT 1 AS week_number
UNION ALL
SELECT week_number + 1
FROM missing_weeknum
WHERE week_number < 52
)

SELECT *
FROM missing_weeknum
WHERE week_number NOT IN(
  SELECT DISTINCT week_number
  FROM clean_weekly_sales
) option (maxrecursion 1000)

````

**Answer:**

![Screen Shot 2023-06-24 at 9 57 39 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/07148554-cb30-406c-a134-3301002caa40)

We don't have 28 weeks of data between weeks 1-12 and 13-28

