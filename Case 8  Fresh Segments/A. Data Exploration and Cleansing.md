# Case Study #8 - Fresh Segments

## Solution - A. Data Exploration and Cleansing

### 1.  Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month



````sql

ALTER TABLE fresh_segments.interest_metrics
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics
SET month_year = CAST(_year + '-' + _month + '-01' AS DATE)




ALTER TABLE fresh_segments.interest_metrics1
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics1
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics1
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))



ALTER TABLE fresh_segments.interest_metrics2
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics2
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics2
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))




ALTER TABLE fresh_segments.interest_metrics3
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics3
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics3
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))



ALTER TABLE fresh_segments.interest_metrics4
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics4
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics4
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))



ALTER TABLE fresh_segments.interest_metrics5
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics5
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics5
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))


ALTER TABLE fresh_segments.interest_metrics6
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics6
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics6
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))


ALTER TABLE fresh_segments.interest_metrics7
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics7
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics7
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))


ALTER TABLE fresh_segments.interest_metrics8
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics8
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics8
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))


ALTER TABLE fresh_segments.interest_metrics9
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics9
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics9
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))

ALTER TABLE fresh_segments.interest_metrics10
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics10
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics10
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))

ALTER TABLE fresh_segments.interest_metrics11
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics11
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics11
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))


ALTER TABLE fresh_segments.interest_metrics12
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics12
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics12
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))


ALTER TABLE fresh_segments.interest_metrics13
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics13
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics13
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))


ALTER TABLE fresh_segments.interest_metrics14
DROP COLUMN month_year

ALTER TABLE fresh_segments.interest_metrics14
ADD month_year VARCHAR(150)

UPDATE fresh_segments.interest_metrics14
SET month_year = CAST(_year + '-' + _month + '-01' AS VARCHAR(150))


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

)

SELECT *
FROM interestmetrics

````


**Answer:**


![Screen Shot 2023-07-19 at 12 46 34 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/ba2f1f92-01d0-4f1a-8a8d-f72224014e89)


Azure data studio currently lets me insert data up to 1000 rows and I am running the SQL server in Azure Data Studio through a SQL server image in Docker as well. I still haven't figured out how to bypass that 1000 row limit so had to split the interest_metrics data into 14 tables and then UNION them all into the interestmetrics CTE. 


If anyone knows how to remove the 1000 row limit through Azure Data Studio or Docker that would be greatly be appreciated!!


***

### 2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?


````sql


SELECT COUNT(*) AS [Number of Records], month_year
FROM interestmetrics
GROUP BY month_year
ORDER BY [Number of Records] DESC

````


**Answer:**


![Screen Shot 2023-07-19 at 12 56 43 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/aa6cdca3-7c23-4b82-a5e0-9a097fae8667)


We can see that on August 1 2019, the highest number of records was 1149.

***



### 3. What do you think we should do with these null values in the fresh_segments.interest_metrics?

We can gather the number of interest ids from the interest metrics table and maps table then use a case statement to check to see whether either don't exist in one of the tables or the other by counting on how much they exist across both tables.


````sql


DELETE FROM fresh_segments.interest_metrics
WHERE month_year IS NULL


DELETE FROM fresh_segments.interest_metrics1
WHERE month_year IS NULL


DELETE FROM fresh_segments.interest_metrics2
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics3
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics4
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics5
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics6
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics7
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics8
WHERE month_year IS NULL


DELETE FROM fresh_segments.interest_metrics9
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics10
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics11
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics12
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics13
WHERE month_year IS NULL

DELETE FROM fresh_segments.interest_metrics14
WHERE month_year IS NULL

````


**Answer:**



***


### 4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?

We can gather the number of interest ids from the interest metrics table and maps table then use a case statement to check to see whether either don't exist in one of the tables or the other by counting on how much they exist across both tables.


Azure data studio currently lets me insert data up to 1000 rows and I am running the SQL server in Azure Data Studio through a SQL server image in Docker as well. I still haven't figured out how to bypass that 1000 row limit so had to split the interest_metrics data into 14 tables and the interest_maps data into 2 tables and then UNION them all into the interestmetrics CTE and the interestmaps CTE respectively. 


If anyone knows how to remove the 1000 row limit through Azure Data Studio or Docker that would be greatly be appreciated!!

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
    FROM fresh_segments.interest_map
    UNION ALL 
    SELECT *
    FROM fresh_segments.interest_map2

)



SELECT COUNT(DISTINCT mi.interest_id) AS [Count of interest values in metrics],
COUNT(DISTINCT ma.id) AS [Count of interest values in map],
COUNT(CASE WHEN mi.interest_id is NULL THEN 1 END)AS [Not in Map],
COUNT(CASE WHEN ma.id is NULL THEN 1 END) AS [Not in Metrics]
FROM interestmetrics AS mi
JOIN interestmap AS ma ON mi.interest_id = ma.id
WHERE mi.interest_id != 'NULL'



````


**Answer:**


![Screen Shot 2023-07-19 at 2 02 16 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/222e2940-6232-47ff-8723-e36e70fe0859)



***


### 5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table

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

SELECT COUNT(*) AS [Number of Records], ma.id, ma.interest_name
FROM interestmap AS ma
INNER JOIN interestmetrics AS mi ON mi.interest_id = ma.id
WHERE mi.interest_id != 'NULL'
GROUP BY ma.id, ma.interest_name
ORDER BY [Number of Records] DESC

````


**Answer:**



![Screen Shot 2023-07-19 at 2 05 22 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/e40b59c3-40ce-4551-902a-ada5cdda4124)

***

### 6.What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.


We will use an inner join because we want to makes sure that id of 21246 exists in both tables so that we can pull the matching records from both tables.

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


SELECT mi.*, ma.*
FROM interestmap AS ma
INNER JOIN interestmetrics AS mi ON mi.interest_id = ma.id
WHERE mi.interest_id = 21246 AND mi.interest_id != 'Null'




````


**Answer:**


![Screen Shot 2023-07-19 at 2 07 49 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/432dc5e4-e729-496c-ab0e-87afd1a1d794)




***

### 7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?


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


SELECT mi.month_year, ma.created_at
FROM interestmap AS ma
INNER JOIN interestmetrics AS mi ON mi.interest_id = ma.id
WHERE --mi.interest_id = 21246 AND 
mi.interest_id != 'Null' AND (mi.month_year < ma.created_at)


````


**Answer:**


![Screen Shot 2023-07-19 at 2 08 48 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/ac61c937-b72a-4c0d-bf0e-d6d78f288de4)


Yes. These records have the same month and the month_year column dates are the first date of the month. Therefore, these records are valid.


***

Click [here](https://github.com/KennethManzi1/8-week-SQL-Challenge/blob/main/Case%208%20%20Fresh%20Segments/B.%20Interest%20Analysis.md) for solution for B. Interest Analysis

