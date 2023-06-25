# Case Study #5 - Data Mart

## Solution - D. Bonus Question

###  Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?

- region
- platform
- age_band
- demographic
- customer_type


### Do you have any further recommendations for Danny’s team at Data Mart or any interesting insights based off this analysis?

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
  sales,
  customer_type
  FROM weeklysales

),


````




Next We will use the week 12 CTEs that we created for parts 1 and 2 to pull the sales metrics performance in 2020 based on the region, platform, age_band, demographic, and customer_ type

We will add customer_type in the Clean Weekly Sales CTE so that we can use it in the week 12 2020 CTEs as well 

**Answer:**

Query below calculates the Growth/Decline in Sales based in the Demographics


````sql

tsales122020 AS(
SELECT Calender_year, --region, platform, Age_band, 
Demographic, --customer_type,
week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 13 and 37) and Calender_year = '2020'
GROUP BY Calender_year, Demographic, week_date, week_number
),


before_after_sales122020 AS(
    SELECT Calender_year, --region, platform, Age_band, 
    Demographic,-- customer_type,
    SUM(CASE WHEN week_number BETWEEN 13 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 37 THEN [Total Sales] END) AS [After Sales]
    FROM tsales122020
    GROUP BY Calender_year, Demographic
)

SELECT [Calender_year], 
--region, platform, Age_band, 
Demographic, --customer_type, 
[Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales122020
ORDER BY [Growth/Decline in Sales]
````
![Screen Shot 2023-06-25 at 3 33 33 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/7549a24b-5202-4116-8b45-99ae3c5f4e6e)

Here we can see that that for unknown demographic, the sales drastically declined at 3.34% while sales for families declined at 1.82% and the sales for couples declined at 0.87% for the year of 2020.

***

Next we will Query based in Region

````sql

tsales122020 AS(
SELECT Calender_year, region, --platform, Age_band, 
--Demographic, --customer_type,
week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 13 and 37) and Calender_year = '2020'
GROUP BY Calender_year, region, week_date, week_number
),


before_after_sales122020 AS(
    SELECT Calender_year, region, --platform, Age_band, 
    --Demographic,-- customer_type,
    SUM(CASE WHEN week_number BETWEEN 13 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 37 THEN [Total Sales] END) AS [After Sales]
    FROM tsales122020
    GROUP BY Calender_year, region
)

SELECT [Calender_year], 
region, --platform, Age_band, 
--Demographic, --customer_type, 
[Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales122020
ORDER BY [Growth/Decline in Sales]

````

![Screen Shot 2023-06-25 at 3 42 01 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/200063c7-1748-4823-8b9d-7e27eea6e358)



***

Next We will query by Platform

````sql

tsales122020 AS(
SELECT Calender_year, platform, --region, Age_band, 
--Demographic, --customer_type,
week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 13 and 37) and Calender_year = '2020'
GROUP BY Calender_year, platform, week_date, week_number
),


before_after_sales122020 AS(
    SELECT Calender_year, platform, --region, Age_band, 
    --Demographic,-- customer_type,
    SUM(CASE WHEN week_number BETWEEN 13 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 37 THEN [Total Sales] END) AS [After Sales]
    FROM tsales122020
    GROUP BY Calender_year, platform
)

SELECT [Calender_year], 
platform, --region, Age_band, 
--Demographic, --customer_type, 
[Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales122020
ORDER BY [Growth/Decline in Sales]


````
![Screen Shot 2023-06-25 at 3 49 15 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/8d6ba9a0-490f-4a4f-954a-40dd5f2528d8)


From this data, we can see that Retail had a drastic decline by 2.43% on 2020 while Shopify improved their growth in sales by 7.18% in 2020


***


Next We will query by age_band

````sql

tsales122020 AS(
SELECT Calender_year, Age_band, --region, platform, 
--Demographic, --customer_type,
week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 13 and 37) and Calender_year = '2020'
GROUP BY Calender_year, Age_band, week_date, week_number
),


before_after_sales122020 AS(
    SELECT Calender_year, Age_band, --region, platform, 
    --Demographic,-- customer_type,
    SUM(CASE WHEN week_number BETWEEN 13 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 37 THEN [Total Sales] END) AS [After Sales]
    FROM tsales122020
    GROUP BY Calender_year, Age_band
)

SELECT [Calender_year], 
Age_band, --region, platform, 
--Demographic, --customer_type, 
[Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales122020
````

![Screen Shot 2023-06-25 at 3 54 26 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/13f12471-1658-4e5a-b22e-85362d991b51)

Based on this data, we can see that across all age types, there was a decline of sales with Young adults only having a small decline in sales while unknown has a major decline of sales at 3.10%

***

Finally we will now query by customer_type



````sql

tsales122020 AS(
SELECT Calender_year, customer_type, --region, platform, 
--Demographic, --Age_band,
week_date, week_number, SUM(CAST(sales as FLOAT)) AS [Total Sales]
FROM clean_weekly_sales 
WHERE (week_number BETWEEN 13 and 37) and Calender_year = '2020'
GROUP BY Calender_year, customer_type, week_date, week_number
),


before_after_sales122020 AS(
    SELECT Calender_year, customer_type, --region, platform, 
    --Demographic,-- Age_band,
    SUM(CASE WHEN week_number BETWEEN 13 and 24 THEN [Total Sales] END) AS [Before Sales],
    SUM(CASE WHEN week_number BETWEEN 25 and 37 THEN [Total Sales] END) AS [After Sales]
    FROM tsales122020
    GROUP BY Calender_year, customer_type
)

SELECT [Calender_year], 
customer_type, --region, platform, 
--Demographic, --Age_band, 
[Before Sales], [After Sales], [After Sales] - [Before Sales] AS [Sales Time Diff], ROUND(100*([After Sales] - [Before Sales])/ [Before Sales],2) AS [Growth/Decline in Sales]
FROM before_after_sales122020
````

![Screen Shot 2023-06-25 at 3 59 24 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/1e4e0353-0973-4143-bcf0-57cfb92dbf81)


- Based on the data, we can see that New customer sales had a small growth of 1.01% in sales in 2020.
- However, Guest and existing customer sales had a small decline of 3% and 2.27% respectively in 2020.

