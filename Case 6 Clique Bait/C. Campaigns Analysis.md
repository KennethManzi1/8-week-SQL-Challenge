# Case Study #3 - Foodie-Fi

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

- We will first create a CTE in postgres that pulls in the following records
    - Within the CTE  will first pull User_id from the users table
    - Then we will pull the Visit id from the events table
    - Aterwords we will calculate the visit_start_time from the events table which is the earliest start time by using the MIN function for this field to get that early start time
    - We will be pulling the Page_views, purchase and add_to_cart CASE statements that we created on question 8 from PART A to calculate the number of page views, purchases and add to cart items per customer.
    - We will using the same case statements alongside sum to find the count of ad impressions and Same thing with Click as well.
    - To get the cart orders, we will use a Postgres function called STRING_AGG which is an aggregate function of CONCAT that takes the records and concatenates them into a single string.
    - So in this case we will use it to get the products that were added to cart and then separate them by a comma while organizing them based on a sequence number which is the order added to the cart.



````sql





````


**Answer:**


