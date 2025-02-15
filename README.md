# Danny_Diner

## Introduction:

Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

## Problem Statement:

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

sales
menu
members


## Datasets:

### Salesu
The sales table captures all customer_id level purchases with an corresponding `order_date` and `product_id` information for when and what menu items were ordered.

![image](https://github.com/user-attachments/assets/64c87dc0-4773-4889-907c-f68f4212909d)


### Menu

The menu table maps the product_id to the actual product_name and price of each menu item.

### Members

The final members table captures the join_date when a customer_id joined the beta version of the Danny's Diner loyalty program

* For Schema of the above sql project

  Refer to https://8weeksqlchallenge.com/case-study-1/ above link

# Case Study Question:

Each of the following case study questions can be answered using a single SQL statement:

*What is the total amount each customer spent at the restaurant?
*How many days has each customer visited the restaurant?
*What was the first item from the menu purchased by each customer?
*What is the most purchased item on the menu and how many times was it purchased by all customers?
*Which item was the most popular for each customer?
*Which item was purchased first by the customer after they became a member?
*Which item was purchased just before the customer became a member?
*What is the total items and amount spent for each member before they became a member?
*If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
*In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

#Insights:

* Customer B is the most frequent visitor with 6 visits in Jan 2021
* Danny's Dinner most popular item is ramen, followed by curry and sushi
* Customer A and C loves ramen , whereas Customer B seems to enjoy sushi, curry and ramen equally. Who knows, I might be Customer B
* Customer A is the 1st member of Danny's Dinner and his first item is curry
* The last item ordered by Cust A and B before they become members are sushi and curry.
* Throughout Jan 2021, their points for Cust A:860 AND Cust B:940 and Cust C:360
* Before they become members, both Cust A AND B spent $25 and $40 
