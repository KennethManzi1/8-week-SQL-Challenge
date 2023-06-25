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

);

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

## 3. How many total transactions were there for each year in the dataset?
````sql
SELECT Calender_year, SUM(transactions) AS [total transactions]
FROM clean_weekly_sales
GROUP BY Calender_year
ORDER BY Calender_year

````

**Answer:**
![Screen Shot 2023-06-24 at 10 04 10 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/ed193b13-1737-47fc-b5dd-f1b939b71462)

- In 2018 there were 346406460 total transactions.
- In 2019 there were 365639285 total transactions.
- In 2020 there were 375813651 total transactions.

## 4. What is the total sales for each region for each month?

````sql
SELECT SUM(ts.sales) AS [Total Sales], ts.region, ts.Month_number
FROM
(
SELECT CAST(sales AS FLOAT) AS sales, region, Month_number
FROM clean_weekly_sales
)ts
GROUP BY ts.region, ts.Month_number
ORDER BY ts.Month_number

````
**Answer:**

![Screen Shot 2023-06-24 at 10 07 53 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/1b5f36ad-0371-40dc-a27c-3e930f4d7887)


## 5. What is the total count of transactions for each platform

````sql
SELECT platform, SUM(transactions) AS [Total transactions]
FROM clean_weekly_sales
GROUP BY platform
````

**Answer:**

![Screen Shot 2023-06-24 at 10 10 31 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/c85f18ac-1259-4d9b-88bf-89b58d05b3c6)

- Retail has a total of 1081934227 transactions
- Shopify has a total of 5925169 transactions

## 6. What is the percentage of sales for Retail vs Shopify for each month?

````sql
SELECT perc.Calender_year, perc.Month_number, ROUND(100 * MAX(CASE WHEN platform = 'Shopify' Then perc.[monthly sales]
ELSE NULL END)/ SUM([monthly sales]), 2) AS [Shopify Percentage],

ROUND(100 * MAX(CASE WHEN platform = 'Retail' Then perc.[monthly sales]
ELSE NULL END)/ SUM([monthly sales]), 2) AS [Retail Percentage]

FROM
(
SELECT Calender_year, Month_number, platform, SUM(CAST(Sales AS float)) AS [monthly sales]
FROM clean_weekly_sales
GROUP BY Calender_year, Month_number, platform
)perc 
GROUP BY perc.Calender_year, perc.Month_number
ORDER BY perc.Month_number
````
**Answer:**
![Screen Shot 2023-06-24 at 10 12 13 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/e3b6f1e0-73cc-4a8b-89eb-c378a2585b4d)

## 7. What is the percentage of sales by demographic for each year in the dataset?

````sql
SELECT perc.Calender_year, ROUND(100 * MAX(CASE WHEN Demographic = 'Couples' Then perc.[Yearly sales]
ELSE NULL END)/ SUM([Yearly sales]), 2) AS [Sales Percentage by Couples],

ROUND(100 * MAX(CASE WHEN Demographic = 'Families' Then perc.[Yearly sales]
ELSE NULL END)/ SUM([Yearly sales]), 2) AS [Sales Percentage by Families],

ROUND(100 * MAX(CASE WHEN Demographic = 'Unknown' Then perc.[Yearly sales]
ELSE NULL END)/ SUM([Yearly sales]), 2) AS [Sales Percentage by Unknown]

FROM
(
SELECT Calender_year, Demographic, SUM(CAST(Sales AS float)) AS [Yearly sales]
FROM clean_weekly_sales
GROUP BY Calender_year, Demographic
)perc
GROUP BY perc.Calender_year
ORDER BY perc.Calender_year
````
**Answer:**

![Screen Shot 2023-06-24 at 10 14 47 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/be6d8a73-198d-4059-b6bf-207da8dc2b34)

## 8. Which age_band and demographic values contribute the most to Retail sales?

````sql
SELECT Age_band, Demographic, SUM(CAST(sales AS FLOAT)) AS [Sales in retail], 
ROUND(100 * SUM(CAST(sales AS float)),2)/ (SELECT SUM(CAST(sales AS FLOAT))  FROM clean_weekly_sales) AS [Contribution]
FROM clean_weekly_sales 
WHERE platform = 'Retail'
GROUP BY Age_band, Demographic
ORDER BY [Sales in retail]
````

**Answer:**
![Screen Shot 2023-06-24 at 10 16 35 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/9dbc62e7-72d4-4aa7-9de0-d6ce05c03bf4)

## 9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

- No we cannot use the avg_transaction column to find the average transaction size for each year because that is only calculating one sale per record divided by one transaction per record so that won't bring the right result because it will divide the sales and transactions per record.
  
- To calculate the average transaction size for each year for retail vs shopify, we will need to find the total number of sales and divide that by the total number of transactions to get the right result.


````sql

SELECT Calender_year, platform, ROUND(SUM(CAST(sales AS FLOAT))/ SUM(transactions), 2) AS [Average transaction size]
FROM clean_weekly_sales 
GROUP BY Calender_year, platform
ORDER BY Calender_year

````


**Answer:**

![Screen Shot 2023-06-24 at 10 21 10 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/d7620b68-a4f3-42aa-8c59-a4ecc5bfc464)


Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%205%20Data%20Mart/C.%20Before%20&%20After%20Analysis.md)
for solution for C. Before & After Analysis





