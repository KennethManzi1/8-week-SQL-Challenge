# Case Study #5 - Data Mart

## Solution - A.  Data Cleansing Steps

In a single query, perform the following operations and generate a new table in the `data_mart` schema named `clean_weekly_sales`:
- Convert the `week_date` to a `DATE` format
- Add a `week_number` as the second column for each `week_date` value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
- Add a `month_number` with the calendar month for each `week_date` value as the 3rd column
- Add a `calendar_year` column as the 4th column containing either 2018, 2019 or 2020 values
- Add a new column called `age_band` after the original segment column using the following mapping on the number inside the segment value
  
<img width="166" alt="image" src="https://user-images.githubusercontent.com/81607668/131438667-3b7f3da5-cabc-436d-a352-2022841fc6a2.png">
  
- Add a new `demographic` column using the following mapping for the first letter in the `segment` values:  

| segment | demographic | 
| ------- | ----------- |
| C | Couples |
| F | Families |

- Ensure all `null` string values with an "unknown" string value in the original `segment` column as well as the new `age_band` and `demographic` columns
- Generate a new `avg_transaction` column as the sales value divided by transactions rounded to 2 decimal places for each record
**Answer:**

We will first create a CTE for weekly Sales as the data is too big to be fit into one table so I will split it into 17 tables and combine them all in a CTE using a UNION
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
````
In a single query we will create a CTE table called clean_weekly_sales that is in date format.
We will create the following columns using the following actions below:
- Weekdate column. CASTING the week_date Column as a date.
- Weeknumber column: We will use DATEPART to pull the week of the date.
- Month_Number column: We will use the DatePART to pull the month of the date.
- Calender_year column: Using DATEPART to pull the year digit of the date.
- Region column: Pulling from Weeklysales CTE.
- Platform column: Pulling from Weeklysales CTE.
- Segment Column: Pulling from Weeklysales CTE.
- Age_band column: Use Case Statement based on right segment. If 1 then Young Adults, If 2 then Middle Aged, IF 3/4 then retires, IF Null then unknown.
- Demographic column: Use case statement based on left of segment. If C then couples. If  F then families. If Null then unknown.
- Transactions column: Pulling from Weeklysales CTE.
- Avg_transactions. Convert sales into float then divide sales by transactions and round to two decimal places.
- Sales column: Pulling from Weeklysales CTE.

````sql
--clean_weekly_sales CTE

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

SELECT *
FROM clean_weekly_sales

````

![Screen Shot 2023-06-23 at 10 18 40 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/adb8b8ef-a34b-45e4-be45-fb60bba9f2ee)


Click [here]
for solution for B. Data Exploration

