# Case Study #8 - Fresh Segments

## Solution - C. Segment Analysis


We will use the interestmetrics CTE and interestmaps CTE to solve all the problems in C.


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
SELECT r.*, RANK() OVER(ORDER BY r.[Maximum Composition] DESC) AS rank
FROM
(
SELECT TOP 10 mt.month_year, mc.interest_id, mp.interest_name, MAX(mt.composition) AS [Maximum Composition]
FROM monthcounts as mc
LEFT JOIN interestmetrics AS mt ON mc.interest_id = mt.interest_id
LEFT JOIN interestmap AS mp on mc.interest_id = mp.id
GROUP BY mt.month_year, mc.interest_id, mp.interest_name
ORDER BY [Maximum Composition] DESC
)r
````

**Answer:**

![Screen Shot 2023-07-23 at 9 24 32 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/3ca71e23-5d89-45ee-881e-3893e86c4a44)




- We got the top 10 interests with the largest compositions.
- Now we will get the bottom 10 interests by ordering the composition in ascending order

````sql

SELECT r.*, RANK() OVER(ORDER BY r.interest_id, r.[Maximum Composition]) AS rank
FROM
(
SELECT TOP 10 mt.month_year, mc.interest_id, mp.interest_name, MAX(mt.composition) AS [Maximum Composition]
FROM monthcounts as mc
LEFT JOIN interestmetrics AS mt ON mc.interest_id = mt.interest_id
LEFT JOIN interestmap AS mp on mc.interest_id = mp.id
GROUP BY mt.month_year, mc.interest_id, mp.interest_name
ORDER BY [Maximum Composition] 
)r

````

**Answer:**

![Screen Shot 2023-07-23 at 9 39 15 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/299176c0-a376-40ac-b253-88a89996dd5e)



***


### 2. Which 5 interests had the lowest average ranking value?

- Same thing as the previous question except this time we are finding the  top 5 interests with the lowest Average ranking instead of largest composition

````sql
SELECT TOP 5 mc.interest_id, mp.interest_name, AVG(mt.ranking) AS [Average Ranking]
FROM monthcounts as mc
LEFT JOIN interestmetrics AS mt ON mc.interest_id = mt.interest_id
LEFT JOIN interestmap AS mp on mc.interest_id = mp.id
GROUP BY mc.interest_id, mp.interest_name
ORDER BY [Average Ranking]
````


**Answer:**

![Screen Shot 2023-07-23 at 1 45 33 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/22e4ae81-8c1a-4c4b-abf9-d0f8c022795d)


***


### 3. Which 5 interests had the largest standard deviation in their percentile_ranking value?

- Same thing as the previous question except this time we are finding the top 5 interests with the largest standard deviation in their percentile value.

- We will order by the standard deviation of the percentile ranking value DESC.

````sql
SELECT TOP 5 mc.interest_id, mp.interest_name, ROUND(STDEV(mt.percentile_ranking),2) AS [Standard Deviation Percentile Rank value]
FROM monthcounts as mc
LEFT JOIN interestmetrics AS mt ON mc.interest_id = mt.interest_id
LEFT JOIN interestmap AS mp on mc.interest_id = mp.id
GROUP BY mc.interest_id, mp.interest_name
ORDER BY [Standard Deviation Percentile Rank value] DESC

````


**Answer:**

![Screen Shot 2023-07-23 at 1 48 43 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/2314d821-d7b2-47a5-9752-4735ccdbb0f4)


***


### 4. For the 5 interests found in the previous question - what was minimum and maximum percentile_ranking values for each interest and its corresponding year_month value? Can you describe what is happening for these 5 interests?

- First we will use the query from question 3 that generated the 5 interests for their standard deviation percentile as a subquery to get the Min and Max percentile rank and convert it as a CTE

````sql
,Percentile AS(
SELECT mx.interest_id, mx.interest_name, MIN(mt.percentile_ranking) AS [Minimum Percentile ranking], MAX(mt.percentile_ranking) AS [Maximum Percentile ranking]
FROM interestmetrics AS mt
JOIN
(
SELECT TOP 5 mc.interest_id, mp.interest_name, ROUND(STDEV(mt.percentile_ranking),2) AS [Standard Deviation Percentile Rank value]
FROM monthcounts as mc
LEFT JOIN interestmetrics AS mt ON mc.interest_id = mt.interest_id
LEFT JOIN interestmap AS mp on mc.interest_id = mp.id
GROUP BY mc.interest_id, mp.interest_name
ORDER BY [Standard Deviation Percentile Rank value] DESC
)mx ON mx.interest_id = mt.interest_id
GROUP BY mx.interest_id, mx.interest_name
)

````

- With the percentile CTE we will calculate the Min percentile values and Max percentile values per month_year with two queries.
  
- Minimum percentile values per month_year.

````SQL
SELECT DISTINCT mx.interest_id, mx.interest_name, mx.[Minimum Percentile ranking], mt.percentile_ranking, mt.month_year
FROM Percentile AS mx
JOIN interestmetrics AS mt on mx.interest_id =mt.interest_id
WHERE mx.[Minimum Percentile ranking] = mt.percentile_ranking
````


![Screen Shot 2023-07-23 at 1 51 40 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/286948f2-72a0-46a8-a945-eb6a5bdcab78)



- Maximum percentile values per month_year




````sql
SELECT DISTINCT mx.interest_id, mx.interest_name, mx.[Maximum Percentile ranking], mt.percentile_ranking, mt.month_year
FROM Percentile AS mx
JOIN interestmetrics AS mt on mx.interest_id =mt.interest_id
WHERE mx.[Maximum Percentile ranking] = mt.percentile_ranking

````

![Screen Shot 2023-07-23 at 1 53 10 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/8823cced-0f63-49d5-ac8e-f760abf73c19)


- Joining the two together for analysis


````sql
,Minval AS
(
SELECT DISTINCT mx.interest_id, mx.interest_name, mx.[Minimum Percentile ranking], mt.percentile_ranking, mt.month_year
FROM Percentile AS mx
JOIN interestmetrics AS mt on mx.interest_id =mt.interest_id
WHERE mx.[Minimum Percentile ranking] = mt.percentile_ranking
)
,Maxval AS
(
SELECT DISTINCT mx.interest_id, mx.interest_name, mx.[Maximum Percentile ranking], mt.percentile_ranking, mt.month_year
FROM Percentile AS mx
JOIN interestmetrics AS mt on mx.interest_id =mt.interest_id
WHERE mx.[Maximum Percentile ranking] = mt.percentile_ranking
)

SELECT mn.interest_id, mn.interest_name, mn.month_year AS [Month year min], mn.[Minimum Percentile ranking], mx.month_year AS [Month Year Max],
mx.[Maximum Percentile ranking]
FROM minval as mn
INNER JOIN maxval as mx ON mn.interest_id = mx.interest_id
ORDER BY [Month year min], [Month Year Max]
````

**Answer:**

![Screen Shot 2023-07-23 at 1 54 17 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/468ac600-8958-4737-bf46-0b3630df30cd)


- During March, the percentile rankings were lower for the interests but as we can see during months July and August the percentile rankings were higher for each interest.

- We can see that interest ID 20764 and 23 have the highest percentile rankings during July and August which means tthat the customers were interacting with them during that time period


***


### 5. How would you describe our customers in this segment based off their composition and ranking values? What sort of products or services should we show to these customers and what should we avoid?

- Based on the data, we can see that lots of the customers like to shop retail products, are very active and 


**Answer:**

- Based on the data, we can see that lots of the customers like to shop retail products, are very active and travel frequently which means that that the team should market and sell products that relate to traveling, fitness such as gym equipments, and retail as we can see from the composition and ranking that many customers like to shop for retail, stay active, and travel frequently by booking hotels and planning for trips.

- Products to avoid selling would be LED lighting and winter apparels(This may depend on location and the time of the season).
- For the winter apparels, you wouldn't want to sell those in the summer particularly June - August because customers are more focusing on planning trips, maybe competing for triatholons or other physical activities more so than worrying about winter storms.
- Around September/October that will change as the weather gets more colder and now customers will start worrying about being prepared for the cold and snow storms as fall approaches.
- We also need to focus on the interests with high composition value but we need to track this metric to define when customers lose their interest in the topic such as purchasing gym equipments or winter apparels


***

Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%208%20%20Fresh%20Segments/D.%20Index%20Analysis.md) for solution for D. Index Analysis

