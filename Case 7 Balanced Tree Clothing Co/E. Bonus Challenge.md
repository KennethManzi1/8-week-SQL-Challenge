# Case Study #7 - Balanced Tree Clothing Co

## Solution - E. Bonus Challenge

### 1. Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.

### Hint: you may want to consider using a recursive CTE to solve this problem!

***

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

- For this problem a self join will also work as we will need to self join the product hierarchy table twice to separate and get the Category id and names and the Segment id and name.
  
- We will create a subquery to conduct all the self-joins per category and segment to pull those fields and join them back to the style hierarchy of the product hierarchy table.

- On the outer query we will pull in the product_prices  and Concat the category, segment, and style name into the product name.



````sql
SELECT hh.style_id, hh.[Segment ID], hh.[Category ID], p.product_id, hh.Style, hh.Category, hh.Segment, CONCAT(hh.Style, ' ', hh.Segment, ' - ', hh.Category) AS [Product Name], p.price
FROM 
(
SELECT st.id AS style_id, st.level_text AS [Style], c.parent_id AS [Category ID], c.level_text AS [Category], s.parent_id AS [Segment ID], s.level_text AS [Segment]
FROM dbo.product_hierarchy AS st
JOIN(
  SELECT * 
  FROM dbo.product_hierarchy
  --WHERE id BETWEEN 1 and 2
)c ON st.parent_id = c.id
JOIN (
  SELECT *
  FROM dbo.product_hierarchy
  --WHERE id BETWEEN 7 AND 8
)s ON st.parent_id = s.id
WHERE st.id BETWEEN 7 AND 18
)hh
JOIN product_prices AS p ON hh.style_id = p.id

````


**Answer:**

![Screen Shot 2023-07-13 at 3 53 13 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/b918e74a-ef90-4b72-9527-21552ac125d5)


- We can see here that we managed to recreate the product_details table by self joining the product hierarchy at the capability and segment levels and later pulling the product prices afterwords.



- Product Details table below for reference

````sql
SELECT *
FROM dbo.product_details
````

![Screen Shot 2023-07-13 at 3 54 57 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/d5994c2b-1c80-4657-a8d4-6662ae729e0d)

- Disclaimer:
    - I tried to recreate the product details table in a recursive CTE but my query got terminated as it went over the Max Recursion limit.
    - I would love feedback on an efficient way to write this recursive CTE or if I am missing key details for this query. The query is currently commented out.
    - This is why I did the self join way as I thought it was efficient to self join the product hierachy table at the category and the segment level and join them back to the style level of the product hierarchy table.

/*
Recur AS(
  SELECT *
  FROM dbo.product_hierarchy
  --WHERE parent_id IS NULL

UNION ALL 

SELECT r.*
FROM recur AS r
JOIN dbo.product_hierarchy AS p ON r.parent_id = p.id

) 

SELECT *
FROM recur
option (maxrecursion 32767)

*/


***
