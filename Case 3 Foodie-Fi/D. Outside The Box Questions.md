# Case Study #3 - Foodie-Fi

## Solution - D. Outside The Box Questions

### The following are open ended questions which might be asked during a technical interview for this case study - there are no right or wrong answers, but answers that make sense from both a technical and a business perspective make an amazing impression!

1. How would you calculate the rate of growth for Foodie-Fi?
```sql

WITH count_calcs AS(
SELECT DATEPART(month, subs.start_date) AS [Month], LAG(COUNT(subs.customer_id), 1) OVER( ORDER BY DATEPART(month, subs.start_date)) AS [Number of Customers in the past],
COUNT(customer_id) AS [Current Number of customers], 100 * (COUNT(customer_id)- LAG(COUNT(subs.customer_id), 1) OVER( ORDER BY DATEPART(month, subs.start_date)) / LAG(COUNT(subs.customer_id), 1) OVER( ORDER BY DATEPART(month, subs.start_date))) AS [Rate Growth]
FROM dbo.subscriptions AS subs
LEFT JOIN dbo.plans as pn ON subs.plan_id = pn.plan_id
WHERE pn.plan_name != 'trial' AND pn.plan_name != 'churn'
GROUP BY subs.start_date
)

SELECT CAST([Rate Growth] AS Decimal)
FROM count_calcs
```

2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?

- Total number of the customers on a certain date,
- number of active customers whether they are on trial, churned or not
- number of paying customers whether they were on trial, churned or not
- number of new customers on a certain date,
- ratio new to churn customers - to understand if the company grows or losing their customers,
- revenue: total revenue, recurring revenue, average revenue per user (ARPU), average revenue per paying user (ARPPU)
- number of active customers by plans - to understand what plan do customers prefer, and to see growth points

3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?
- I think it would helpful to compare if the customers stick with the subscription and upgrade after using the free trial on the final day vs the customers who use the free trial and decide not to go along with the subscription after the final day. 

- This may help gather the numbers on how many customers upgrade to the subscription and how many customers leave after the free trial to figure out ways to retain and increase customers. Also it would help to figure out the service usage. 

- For customers who used the free trial version, we can analyze how many times they've used it, or not at all to better get an understanding of their preferences and as for the customers with the subscriptions, we can figure out the services and features they used and enjoyed that were offered by the subscriptions and how long they've used them while getting feedback for improvement and innovation.


4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?

    1. What was your reasoning of cancelling Foodie-Fi?
  

    2. Where you satisfied with the app? Did it meet your expectations? If not, what can we do to make sure it meets expectations?


    3. How can improve the quality and service of Foodie-Fi?

    4. What would it take for you to return to Foodie-Fi? 
    5. Did you encounter any issues while using the Foodie-Fi service?
    6. Was customer support helpful with any issues you had with Foodie-Fi?
    7. Would you recommend this service to a friend or a family member?

5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?
- When a user sign-ups, the Foodie-Fi goal is to convert the user into customer as quick as possible. Furthermore, we need to show them features of the paid plans and offer a special discount for early subscription for pro plans.

- After the trial ends, it is possible to offer another discount to keep the customer drawn into the service.

- Rewarding customers for for their loyalty with bonus points for their future purchases.

- Allow the customers to provide feedback so that the user or a customer has an option to easily share their opinion.

- Sometimes users are ready to pay but just cannot do it because of some technical problems or something that can be resolved easily.

- If a paying user cancels the subscription then we can ask them about the reasons such as why they decided to cancel their subscription?

- How to validate: A/B tests, number of active customers by date 



