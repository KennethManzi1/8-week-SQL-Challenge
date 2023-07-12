# Case Study #7 - Balanced Tree Clothing Co

## Solution - D. Reporting Challenge

### 1. Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.

### Imagine that the Chief Financial Officer (which is also Danny) has asked for all of these questions at the end of every month.

### He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).

### Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)


- Because the Sales data is over 150000 rows and Azure Data studio so far only lets me insert 1000 rows of data per table, I decided to create 15 CTEs to insert data and UNION them all in a CTE called saless

````SQL

  WITH Saless AS
  (
    SELECT *
    FROM sales
    
    UNION ALL
    
    SELECT *
    FROM sales1
    
    UNION ALL
    
    SELECT *
    FROM sales2 
    
    UNION ALL
    
    SELECT *
    FROM sales3

    UNION ALL
    
    SELECT *
    FROM sales4 

    UNION ALL
    
    SELECT *
    FROM sales5

    UNION ALL
    
    SELECT *
    FROM sales6

    UNION ALL
    
    SELECT *
    FROM sales7

    UNION ALL
    
    SELECT *
    FROM sales8

    UNION ALL

    SELECT *
    FROM sales88

    UNION ALL
    
    SELECT *
    FROM sales9

    UNION ALL
    
    SELECT *
    FROM sales10

    UNION ALL
    
    SELECT *
    FROM sales11

    UNION ALL
    
    SELECT *
    FROM sales12

    UNION ALL
    
    SELECT *
    FROM sales13

    UNION ALL
    
    SELECT *
    FROM sales14
  )
````

***

- The below is the single SQL script that combines all of the questions into a scheduled report that the balanced team can run at the beginning of each month to calculate the previous month's values.
- Currently the script is filtered by January. We can change the filter to February or any other month on the where clause





````sql
sales_monthly AS
(
  SELECT s.*, ROUND(AVG(s.[Total quantity products]), 1) AS [Average Unique Products], ROUND(AVG(s.[Total Revenue before discounts]), 1) AS [Average Revenue], ROUND(AVG(s.[Total Discount]), 1) AS [Average Discount],
  PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY s.[Total Revenue before discounts]) OVER() AS [25th Percentile],
  PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY s.[Total Revenue before discounts]) OVER() AS [50th Percentile],
  PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY s.[Total Revenue before discounts]) OVER() AS [75th Percentile]
  FROM
  (
  SELECT pd.category_id, pd.category_name AS [Category], pd.product_id, pd.product_name AS [Product], RANK() OVER(PARTITION BY pd.segment_id ORDER BY SUM(sls.qty)) AS [Ranked Products], pd.segment_id, pd.segment_name AS [Segment], sls.txn_id AS [Transactions], sls.member, ROUND(100 * CAST(COUNT(sls.member) AS FLOAT)/(SELECT COUNT(member) FROM saless),2) AS [Member Percentage], COUNT(DISTINCT sls.txn_id) AS [Number of Transactions], SUM(qty) AS [Total quantity products], SUM(sls.qty * sls.price) AS [Total Revenue before discounts], ROUND(SUM(sls.qty * sls.price * CAST(discount AS FLOAT)), 2) AS [Total Discount],
  DATENAME(MONTH, start_txn_time) AS [Month], DATENAME(YEAR, start_txn_time) AS [Year]
  FROM saless sls
  INNER JOIN product_details AS pd ON  sls.prod_id = pd.product_id
  WHERE DATEPART(MONTH, start_txn_time) = 1 AND DATEPART(YEAR, start_txn_time) = '2021'
  GROUP BY DATENAME(MONTH, start_txn_time), DATENAME(YEAR, start_txn_time), txn_id, member, pd.product_id, pd.product_name, pd.segment_id, pd.segment_name, pd.category_id, pd.category_name
  )s
  GROUP BY s.[Number of Transactions], s.[Total Discount], s.[Total quantity products], s.[Total Revenue before discounts], s.[Month], s.[Year], s.Transactions, s.member, s.[Member Percentage], s.product_id, s.Product, s.segment_id, s.Segment, s.[Ranked Products], s.Category, s.category_id
)

SELECT DISTINCT *
FROM sales_monthly

````


**Answer:**

![Screen Shot 2023-07-12 at 4 55 30 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/52d2db24-b675-49dd-b3d2-0260dba0378f)


