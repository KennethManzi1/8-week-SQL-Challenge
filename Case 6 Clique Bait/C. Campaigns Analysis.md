# Case Study #6 - Clique Bait

## Solution - C. Campaigns Analysis

### 1. Generate a table that has 1 single row for every unique visit_id record and has the following columns:

- user_id
- visit_id
- visit_start_time: the earliest event_time for each visit
- page_views: count of page views for each visit
- cart_adds: count of product cart add events for each visit
- purchase: 1/0 flag if a purchase event exists for each visit
- campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
- impression: count of ad impressions for each visit
- click: count of ad clicks for each visit
- (Optional column) cart_products: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the sequence_number)

## Use the subsequent dataset to generate at least 5 insights for the Clique Bait team - bonus: prepare a single A4 infographic that the team can use for their management reporting sessions, be sure to emphasise the most important points from your findings.

Some ideas you might want to investigate further include:

Identifying users who have received impressions during each campaign period and comparing each metric with other users who did not have an impression event
Does clicking on an impression lead to higher purchase rates?
What is the uplift in purchase rate when comparing users who click on a campaign impression versus users who do not receive an impression? What if we compare them with users who just an impression but do not click?
What metrics can you use to quantify the success or failure of each campaign compared to eachother?

***

- We will first create a CTE in Postgres that pulls in the following records
    - Within the CTE  will first pull User_id from the users table
    - Then we will pull the Visit id from the events table
    - Afterwords we will calculate the visit_start_time from the events table which is the earliest start time by using the MIN function for this field to get that early start time
    - We will be pulling the Page_views, purchase and add_to_cart CASE statements that we created on question 8 from PART A to calculate the number of page views, purchases and add to cart items per customer.
    - We will using the same case statements alongside sum to find the count of ad impressions and Same thing with Click as well.
    - To get the cart orders, we will use a Postgres function called STRING_AGG which is an aggregate function of CONCAT that takes the records and concatenates them into a single string.
    - So in this case we will use it to get the products that were added to cart and then separate them by a comma while organizing them based on a sequence number which is the order added to the cart.



````sql
WITH user_records AS(

SELECT u.user_id, e.visit_id, MIN(e.event_time) AS visit_start_time, c.campaign_name, SUM(CASE WHEN i.event_name = 'Page View' THEN 1 ELSE 0 END) AS page_views,
SUM(CASE WHEN i.event_name = 'Add to Cart' THEN 1 ELSE 0 END) AS
add_to_cart, SUM(CASE WHEN i.event_name = 'Ad Impression' THEN 1 ELSE 0 END) AS Ad_Impression, 

SUM(CASE WHEN i.event_name = 'Add to Cart' THEN 1 ELSE 0 END) AS
add_to_cart, SUM(CASE WHEN i.event_name = 'Purchase' THEN 1 ELSE 0 END) AS Purchase,

SUM(CASE WHEN i.event_name = 'Ad Click' THEN 1 ELSE 0 END) AS Ad_Click,
STRING_AGG(CASE WHEN i.event_name = 'Add to Cart' AND PH.product_id IS NOT NULL THEN PH.page_name ELSE NULL END, ', ' ORDER BY e.sequence_number) AS cart_products

FROM clique_bait.users AS u
LEFT JOIN clique_bait.events AS e ON u.cookie_id = e.cookie_id
LEFT JOIN clique_bait.page_hierarchy AS PH ON e.page_id = ph.page_id
LEFT JOIN clique_bait.event_identifier AS i ON e.event_type = i.event_type
LEFT JOIN clique_bait.campaign_identifier AS c ON e.event_time BETWEEN c.start_date AND c.end_date
  
GROUP BY u.user_id, e.visit_id, c.campaign_name
)

SELECT *
FROM user_records
WHERE user_id = 1
ORDER BY page_views


````


**Answer:**


![Screen Shot 2023-07-02 at 2 07 46 PM](https://github.com/KennethManzi1/8-week-SQL-Challenge/assets/120513764/491c81bf-c3e3-4d78-94ec-59750f544c27)


### Five key insights from C that will help Danny and his team

- Page views and clicks vs buying the product: Based on the data that the query generated, the team can identify how they can increase the cart-adds and purchases from the amount of page views viewed from customers and the amount of clicks. Essentially, the team can should work on going from bringing the customer to click the page and view it to the purchase based on the customer's preferences and if they like the product.
  
- Impressions vs clicks: Improving the impressions and clicks may lead to the customer wanting to buy the product after they viewed the campaign.
  
- Campaign impact: Which campaigns lead to better success in terms of the customers buying the products vs which campaigns lead to subpar results? Can compare campaign impacts to better figure out which campaigns were more impactful or less impactful in key areas such as clicks, views and impressions and can work on implementing improvements based on the feedback.
  
- Adding products to carts ---> purchase?: What is the impact of a customer adding a product to the cart after they view or click the campaign? Does the customer ultimately purchase the product or not?
  
- More emphasis on impressions and clicks as some users have lower impressions and clicks but have higher page views and cart ads.
