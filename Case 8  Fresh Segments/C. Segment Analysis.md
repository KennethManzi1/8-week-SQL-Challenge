# Case Study #8 - Fresh Segments

## Solution - C. Segment Analysis


We will solve this by pulling the number of distinct interests and the number of distinct month_year in the dataset.

We will use the interestmetrics CTE and interestmaps CTE to solve for B as well.


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

***

### 1. Using our filtered dataset by removing the interests with less than 6 months worth of data, which are the top 10 and bottom 10 interests which have the largest composition values in any month_year? Only use the maximum composition value for each interest but you must keep the corresponding month_year

- First we will create a CTE to grab the interests with at least more than 6 months worth of data.

````sql
monthcounts AS(
    SELECT interest_id, count(DISTINCT month_year) AS month_count
    FROM interestmetrics
    group by interest_id
    having count(distinct month_year) >=6

)

````


- Then we will write a query to get the top 10 interests with at least 6 months worth of data that have the largest(Maximum) composition values in any month_year.
- We will order by the Maximum composition in descending order to get the top 10 interests with the largest composition

````sql
SELECT TOP 10 mt.month_year, mc.interest_id, mp.interest_name, MAX(mt.composition) AS [Maximum Composition]
FROM monthcounts as mc
LEFT JOIN interestmetrics AS mt ON mc.interest_id = mt.interest_id
LEFT JOIN interestmap AS mp on mc.interest_id = mp.id
GROUP BY mt.month_year, mc.interest_id, mp.interest_name
ORDER BY [Maximum Composition] DESC
````

**Answer:**


![Screen Shot 2023-07-23 at 1 37 42 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/ba7961f0-d4cc-417a-a6fc-f3b5508c62bd)


- We got the top 10 interests with the largest compositions.
- Now we will get the bottom 10 interests by ordering the composition in ascending order

````sql
SELECT TOP 10 mt.month_year, mc.interest_id, mp.interest_name, MAX(mt.composition) AS [Maximum Composition]
FROM monthcounts as mc
LEFT JOIN interestmetrics AS mt ON mc.interest_id = mt.interest_id
LEFT JOIN interestmap AS mp on mc.interest_id = mp.id
GROUP BY mt.month_year, mc.interest_id, mp.interest_name
ORDER BY [Maximum Composition] 

````

**Answer:**

![Screen Shot 2023-07-23 at 1 42 47 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/211b47f5-3bd1-41ce-87b2-ebdb334e95b0)


***


### 2. Which 5 interests had the lowest average ranking value?


````sql

````


**Answer:**

***


### 3. Which 5 interests had the largest standard deviation in their percentile_ranking value?


````sql

````


**Answer:**

***


### 4. For the 5 interests found in the previous question - what was minimum and maximum percentile_ranking values for each interest and its corresponding year_month value? Can you describe what is happening for these 5 interests?



````sql

````


**Answer:**

***

### 5. How would you describe our customers in this segment based off their composition and ranking values? What sort of products or services should we show to these customers and what should we avoid?


````sql


````


**Answer:**

***




Click [here] for solution for D. Index Analysis

