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


***



### 1. What is the top 10 interests by the average composition for each month?


````sql


````


**Answer:**


***


### 2. For all of these top 10 interests - which interest appears the most often?


````sql


````


**Answer:**


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
