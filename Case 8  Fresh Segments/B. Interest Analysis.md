# Case Study #8 - Fresh Segments

## Solution - B. Interest Analysis

### 1. Which interests have been present in all month_year dates in our dataset?

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


SELECT COUNT(DISTINCT month_year) AS [Unique Month_year counts], COUNT(DISTINCT interest_id) AS [Unique interest counts ]
FROM interestmetrics
WHERE interest_id != 'Null' AND month_year IS NOT NULL

````


**Answer:**

![Screen Shot 2023-07-19 at 9 20 11 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/48eeab4b-f843-433c-93ff-0aa405fb734c)



*** 


### 2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months - which total_months value passes the 90% cumulative percentage value?


- We will create the CTE to get the month_year counts from question 1 and then we will calculate the number of interest ids as a subquery and then lastly calculate cumulative percentage.
- Cumulative percentage involves calculating running totals so we will need to use a SUM() OVER() function within the percentage formula.
- Then we will filter for the total months value with 90% cumulative or higher

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

),

Uniquemonthsct AS
(
   SELECT DISTINCT interest_id, COUNT(DISTINCT month_year) AS [total_months]
   FROM interestmetrics
   WHERE interest_id != 'Null' AND month_year IS NOT NULL 
   GROUP by interest_id
)


SELECT pp.*
FROM
(
SELECT perc.[total_months], perc.[Interest Counts],
ROUND(100 * SUM(perc.[Interest Counts]) OVER (ORDER BY perc.[total_months] DESC)/ (SUM(perc.[Interest Counts]) OVER()), 3) AS [Cumulative Percentage]
FROM
(
SELECT COUNT(interest_id) AS [Interest Counts], [total_months]
FROM Uniquemonthsct
GROUP BY [total_months]
)perc
)pp
WHERE pp.[Cumulative Percentage] >= 90

````


**Answer:**

![Screen Shot 2023-07-19 at 9 25 28 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/73ac1f8b-b96e-4085-b0bd-cf96622611df)

Here we can see that 6 total_months values have a 90% or higher cumulative percentage.

*** 

### 3. If we were to remove all interest_id values which are lower than the total_months value we found in the previous question - how many total data points would we be removing?

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

),

Uniquemonthsct AS
(
   SELECT DISTINCT interest_id, COUNT(DISTINCT month_year) AS [total_months]
   FROM interestmetrics
   WHERE interest_id != 'Null' AND month_year IS NOT NULL 
   GROUP by interest_id
),


monthcounts AS(
    SELECT interest_id, count(DISTINCT month_year) AS month_count
    FROM interestmetrics
    group by interest_id
    having count(distinct month_year) <6 
)

SELECT COUNT(mi.interest_id) AS [Number of interest ids with month_year less than 6]
FROM interestmetrics mi
LEFT JOIN monthcounts mo ON mi.interest_id = mo.interest_id
WHERE mo.month_count < 6



````

![Screen Shot 2023-07-19 at 9 28 21 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/12e159aa-be5a-487f-a914-4062dd006e21)


**Answer:**

Based on the query, we will be removing 403 interest id values with month_year less than 6.

*** 

### 4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective.


To answer this question, we are going to need to get the present_interest data alongside the removed_interest data along with the month_year



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

),

Uniquemonthsct AS
(
   SELECT DISTINCT interest_id, COUNT(DISTINCT month_year) AS [total_months]
   FROM interestmetrics
   WHERE interest_id != 'Null' AND month_year IS NOT NULL 
   GROUP by interest_id
),



monthcounts AS(
    SELECT interest_id, count(DISTINCT month_year) AS month_count
    FROM interestmetrics
    group by interest_id
    having count(distinct month_year) <6 
)

--Removed Interest Data
SELECT r.month_year AS [Month Year of Removed Interest], p.month_year AS [Month Year of Present Interest], p.[Present Interest],
r.[Removed Interest]
FROM
(
SELECT mi.month_year, COUNT(mi.interest_id) AS [Removed Interest]
FROM interestmetrics mi
LEFT JOIN monthcounts mo ON mi.interest_id = mo.interest_id
WHERE mo.month_count < 6
GROUP by month_year
)r 
--Joining the Present Interest data
JOIN 
(
    SELECT mi.month_year, COUNT(mi.interest_id) AS [Present Interest]
    FROM interestmetrics mi
    LEFT JOIN monthcounts mo ON mi.interest_id = mo.interest_id
    --WHERE mo.month_count >= 6
    GROUP by month_year
)p

ON r.month_year = p.month_year
ORDER by r.month_year

````


**Answer:**


![Screen Shot 2023-07-19 at 9 32 01 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/0ffb86c2-68a6-41e1-b533-5e78b54bfecb)



We can remove the data points as we can see that the removed interest numbers aren't a big significance compared to the present interest numbers so we can remove them


*** 


### 5. After removing these interests - how many unique interests are there for each month?

We can pull the present interest data from question 4 to answer this question


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

),

Uniquemonthsct AS
(
   SELECT DISTINCT interest_id, COUNT(DISTINCT month_year) AS [total_months]
   FROM interestmetrics
   WHERE interest_id != 'Null' AND month_year IS NOT NULL 
   GROUP by interest_id
),


monthcounts AS(
    SELECT interest_id, count(DISTINCT month_year) AS month_count
    FROM interestmetrics
    group by interest_id
    having count(distinct month_year) <6 
)

SELECT mi.month_year, COUNT(mi.interest_id) AS [Present Interest]
FROM interestmetrics mi
LEFT JOIN monthcounts mo ON mi.interest_id = mo.interest_id
--WHERE mo.month_count >= 6
GROUP by month_year
ORDER BY month_year




````


**Answer:**


![Screen Shot 2023-07-19 at 9 34 10 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/d26e3913-e923-4a83-9da2-f8e5d91d36d6)



*** 




Click [here]
for solution for C. Segment Analysis

