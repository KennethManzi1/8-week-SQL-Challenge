# Case Study #8 - Fresh Segments

## Solution - D. Index Analysis


### The index_value is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients. Average composition can be calculated by dividing the composition column by the index_value column rounded to 2 decimal places.

We will use the interestmetrics CTE and interestmaps CTE to solve all the problems in D.


````sql

WITH interestmetrics AS
(
    SELECT *
    FROM fresh_segments.interest_metrics
    UNION ALL


    SELECT *
    FROM fresh_segments.interest_metrics1
    UNION ALL

    SELECT *
    FROM fresh_segments.interest_metrics2
    UNION ALL


    SELECT *
    FROM fresh_segments.interest_metrics3
    UNION ALL


    SELECT *
    FROM fresh_segments.interest_metrics4
    UNION ALL



    SELECT *
    FROM fresh_segments.interest_metrics5
    UNION ALL


    SELECT *
    FROM fresh_segments.interest_metrics6
    UNION ALL


    SELECT *
    FROM fresh_segments.interest_metrics7
    UNION ALL


    SELECT *
    FROM fresh_segments.interest_metrics8
    UNION ALL

    SELECT *
    FROM fresh_segments.interest_metrics9
    UNION ALL


    SELECT *
    FROM fresh_segments.interest_metrics10
    UNION ALL

    SELECT *
    FROM fresh_segments.interest_metrics11
    UNION ALL



    SELECT *
    FROM fresh_segments.interest_metrics12
    UNION ALL



    SELECT *
    FROM fresh_segments.interest_metrics13
    UNION ALL


    SELECT *
    FROM fresh_segments.interest_metrics14   

),

interestmap AS
(
    SELECT *
    FROM fresh_segments.interest_map mp
    UNION ALL 
    SELECT *
    FROM fresh_segments.interest_map2

)
````


- Furthermore in order to solve these problems, we will also need to calculate the average composition with the formula that was provided by Danny Ma above.

- We will use that formula to create a CTE for the average composition

```SQL
,avgcomp AS(
  SELECT *, ROUND(composition/index_value, 2) AS [Avg Composition]
  FROM interestmetrics
)

```

***



### 1. What is the top 10 interests by the average composition for each month?


- With the average composition CTE created, we can now get the interest information and the avg composition and rank them by the average composition per month.

- We will only get the top 10 ranked interests by the average composition per month

````sql


SELECT rr.*
FROM
(
SELECT r.interest_id,  mp.interest_name, r.[Avg Composition], r.month_year, DENSE_RANK() OVER(partition by r.month_year ORDER BY r.[Avg Composition] DESC) AS [Rank]
FROM
(
SELECT *
FROM avgcomp
)r
LEFT JOIN interestmap AS mp ON r.interest_id = mp.id
WHERE interest_id != 'Null' AND r.month_year IS NOT NULL
)rr
WHERE rr.Rank <= 10


````


**Answer:**

![Screen Shot 2023-07-23 at 10 21 20 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/28c495c7-bfbb-4df0-be00-d0b844342732)


***


### 2. For all of these top 10 interests - which interest appears the most often?

- Here we will just count how many times the interest information appears for the top 10 ranked interests.

````sql

SELECT DISTINCT rr.interest_id, rr.interest_name, COUNT(*) AS [COUNT of Interest]
FROM
(
SELECT r.interest_id,  mp.interest_name, r.[Avg Composition], r.month_year, DENSE_RANK() OVER(partition by r.month_year ORDER BY r.[Avg Composition] DESC) AS [Rank]
FROM
(
SELECT *
FROM avgcomp
)r
LEFT JOIN interestmap AS mp ON r.interest_id = mp.id
WHERE interest_id != 'Null' AND r.month_year IS NOT NULL
)rr
WHERE rr.rank <= 10
GROUP BY rr.interest_id, rr.interest_name
ORDER BY [COUNT of Interest] DESC

````



**Answer:**

![Screen Shot 2023-07-23 at 10 23 19 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/134cb11e-ebfe-4bc7-9ac3-146e61c55989)


***


### 3. What is the average of the average composition for the top 10 interests for each month?

- Here we will calcuate the average of the average composition using the previous queries from the previous questions.

- The only difference here is finding the average of the average composition for the top 10 interests for each month


````sql

SELECT avg.month_year, ROUND(AVG(avg.[Avg Composition]), 2) AS [Average of Average Composition per month]
FROM 
(
SELECT r.interest_id,  mp.interest_name, r.[Avg Composition], r.month_year, DENSE_RANK() OVER(partition by r.month_year ORDER BY r.[Avg Composition] DESC) AS [Rank]
FROM
(
SELECT *
FROM avgcomp
)r
LEFT JOIN interestmap AS mp ON r.interest_id = mp.id
WHERE interest_id != 'Null' AND r.month_year IS NOT NULL
)avg
WHERE avg.Rank <= 10
GROUP BY avg.month_year
ORDER BY [Average of Average Composition per month] DESC



````


**Answer:**

![Screen Shot 2023-07-23 at 10 35 36 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/7bac5966-ed89-49de-9422-5096a225a504)




***




### 4. What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.

- This is a 3 or 4 part question as we have to solve and assemble multiple pieces in order to solve the problem.

- The first puzzle we will need to solve for is to find the max average composition and we can create a CTE for this




````sql
,maxavgcomp AS(
  SELECT month_year, ROUND(MAX([Avg Composition]), 2) AS [Max of Average Composition per month]
  FROM avgcomp
  GROUP BY month_year
)
````

![Screen Shot 2023-07-25 at 2 27 17 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/e47b3575-60ab-4f38-bcbe-527065af747d)


- Now that we found the Maximum average compositions, the next puzzle we will need to solve is to find the 3 month rolling average for the maximum compositions between September 2018 and August 2019.

- Since Rolling Average is the same as the running average, we will use the AVG() OVER(ORDER BY) function to find the running/rolling averages and since we are looking for the rolling average in the 3 month period between September, we will further update the window function to use 2 preceding to grab the 2 preceding month records before the current month record.

```SQL
,rollingavg AS(
SELECT mi.interest_id, mi.month_year, mp.interest_name, mx.[Max of Average Composition per month], 
ROUND(AVG(mx.[Max of Average Composition per month]) OVER(ORDER BY mi.month_year ROWS 2 PRECEDING),2) AS [3 month rolling Average]
FROM interestmetrics AS mi 
LEFT JOIN interestmap AS mp ON mi.interest_id = mp.id 
LEFT JOIN avgcomp AS avg ON mi.interest_id = avg.interest_id
LEFT JOIN maxavgcomp AS mx ON mi.month_year = mx.month_year
WHERE avg.[Avg Composition] = mx.[Max of Average Composition per month] AND 
mi.interest_id != 'Null' AND mi.month_year IS NOT NULL
)

SELECT *
FROM rollingavg
```

![Screen Shot 2023-07-25 at 2 30 09 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/99bba167-e81c-470b-a539-792a1aabad1e)


- Lastly, our final puzzle will be grabbing the previous interests for the Max avg composition for those 2 months using the Lag function




```SQL
,prevmonths AS(
  SELECT onemon.*, LAG([Previous Month Interest name]) OVER(ORDER BY month_year) AS [Previous Two Months Interest Name], LAG([Previous Month Max Average Composition]) OVER(ORDER BY month_year) AS [Previous Two Months Max Average Composition]
  FROM
  (
  SELECT *, lAG(interest_name) OVER(ORDER by month_year) AS [Previous Month Interest name], LAG([Max of Average Composition per month]) OVER(ORDER BY month_year) AS [Previous Month Max Average Composition]
  FROM rollingavg
  )onemon
)

SELECT *
FROM prevmonths
WHERE month_year NOT IN ('2018-07-01', '2018-7-01', '2018-08-01', '2018-8-01')


```


**Answer:**


![Screen Shot 2023-07-25 at 2 25 35 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/08290c9e-f11f-4aba-ad40-a50334cae860)  ![Screen Shot 2023-07-25 at 2 25 56 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/1492e10c-be15-444f-97c1-4826a2279371)




***


### 5. Provide a possible reason why the max average composition might change from month to month? Could it signal something is not quite right with the overall business model for Fresh Segments?


````sql


````


**Answer:**


***
