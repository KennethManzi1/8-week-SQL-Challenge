## Case Study #4: Data Bank

<img src="https://user-images.githubusercontent.com/81607668/130343294-a8dcceb7-b6c3-4006-8ad2-fab2f6905258.png" alt="Image" width="500" height="520">

## 📚 Table of Contents
- [Business Task](#business-task)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Question and Solution](#question-and-solution)

Please note that all the information regarding the case study has been sourced from the following link: [here](https://8weeksqlchallenge.com/case-study-4/). 

***

## Business Task
Danny launched a new initiative, Data Bank which runs **banking activities** and also acts as the world’s most secure distributed **data storage platform**!

Customers are allocated cloud data storage limits which are directly linked to how much money they have in their accounts. 

The management team at Data Bank want to increase their total customer base - but also need some help tracking just how much data storage their customers will need.

This case study is all about calculating metrics, growth and helping the business analyse their data in a smart way to better forecast and plan for their future developments!

## Entity Relationship Diagram

<img width="631" alt="image" src="https://user-images.githubusercontent.com/81607668/130343339-8c9ff915-c88c-4942-9175-9999da78542c.png">

**Table 1: `regions`**

This regions table contains the `region_id` and their respective `region_name` values.

<img width="176" alt="image" src="https://user-images.githubusercontent.com/81607668/130551759-28cb434f-5cae-4832-a35f-0e2ce14c8811.png">

**Table 2: `customer_nodes`**

Customers are randomly distributed across the nodes according to their region. This random distribution changes frequently to reduce the risk of hackers getting into Data Bank’s system and stealing customer’s money and data!

<img width="412" alt="image" src="https://user-images.githubusercontent.com/81607668/130551806-90a22446-4133-45b5-927c-b5dd918f1fa5.png">

**Table 3: Customer Transactions**

This table stores all customer deposits, withdrawals and purchases made using their Data Bank debit card.

<img width="343" alt="image" src="https://user-images.githubusercontent.com/81607668/130551879-2d6dfc1f-bb74-4ef0-aed6-42c831281760.png">

***

## Case Study Questions

## A. Customer Nodes Exploration

A. Customer Nodes Exploration
B. How many unique nodes are there on the Data Bank system?
C. What is the number of nodes per region?
D. How many customers are allocated to each region?
E. How many days on average are customers reallocated to a different node?
F. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

View my solution [here]

***

## B. Customer Transactions

1. What is the unique count and total amount for each transaction type?
2. What is the average total historical deposit counts and amounts for all customers?
3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
4. What is the closing balance for each customer at the end of the month?
5. What is the percentage of customers who increase their closing balance by more than 5%?

View my solution [here]

***

## C. Data Allocation Challenge

To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:

Option 1: data is allocated based off the amount of money at the end of the previous month
Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
Option 3: data is updated real-time
For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:

running customer balance column that includes the impact each transaction
customer balance at the end of each month
minimum, average and maximum values of the running balance for each customer
Using all of the data available - how much data would have been required for each option on a monthly basis?

View my solution [here]

***

## D. Extra Challenge

Data Bank wants to try another option which is a bit more difficult to implement - they want to calculate data growth using an interest calculation, just like in a traditional savings account you might have with a bank.

If the annual interest rate is set at 6% and the Data Bank team wants to reward its customers by increasing their data allocation based off the interest calculated on a daily basis at the end of each day, how much data would be required for this option on a monthly basis?

Special notes:

Data Bank wants an initial calculation which does not allow for compounding interest, however they may also be interested in a daily compounding interest calculation so you can try to perform this calculation if you have the stamina!

***


