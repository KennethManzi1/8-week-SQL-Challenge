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

````sql


````


**Answer:**


***


### 4. What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.

````sql


````


**Answer:**


***


### 5. Provide a possible reason why the max average composition might change from month to month? Could it signal something is not quite right with the overall business model for Fresh Segments?


````sql


````


**Answer:**


***
