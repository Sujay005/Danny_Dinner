CREATE SCHEMA dannys_diner;
Use dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);
  
  





CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO menu (product_id, product_name, price)
VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);

INSERT INTO members (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');


SELECT * FROM menu;
SELECT * FROM sales;
SELECT * FROM members;

##What is the total amount each customer spent at the restaurant?##

SELECT SUM(price) AS total_sales, customer_id AS customer
FROM dannys_diner.menu m
JOIN dannys_diner.sales s ON s.product_id = m.product_id
GROUP BY customer_id
ORDER BY total_sales DESC;

##How many days has each customer visited the restaurant?

SELECT COUNT(order_date) AS visits, customer_id
FROM sales
GROUP BY customer_id
ORDER BY visits DESC;

##What was the first item from the menu purchased by each customer?

WITH cte AS (
  SELECT customer_id, order_date, product_name,
  DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS rnk
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m ON m.product_id = s.product_id
)
SELECT customer_id, product_name
FROM cte
WHERE rnk = 1;

##What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT COUNT(s.product_id) AS most_preferred_item, product_name
FROM dannys_diner.menu m
JOIN dannys_diner.sales s ON m.product_id = s.product_id
GROUP BY product_name
ORDER BY most_preferred_item DESC;

##What is the most purchased item on the menu and how many times was it purchased by all customers?

WITH cte AS (
  SELECT customer_id, product_name, COUNT(m.product_id) AS total_count,
  DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(m.product_id) DESC) AS rnk
  FROM dannys_diner.menu m
  JOIN dannys_diner.sales s ON m.product_id = s.product_id
  GROUP BY customer_id, product_name
)
SELECT customer_id, product_name, total_count
FROM cte
WHERE rnk = 1;

##Which item was purchased first by the customer after they became a member?

WITH member_first AS (
  SELECT me.join_date, me.customer_id, s.order_date, s.product_id,
  ROW_NUMBER() OVER (PARTITION BY me.customer_id ORDER BY s.order_date ASC) AS rnk
  FROM dannys_diner.members me
  INNER JOIN dannys_diner.sales s ON s.customer_id = me.customer_id
  AND s.order_date > me.join_date
)
SELECT customer_id, product_name
FROM member_first
INNER JOIN dannys_diner.menu ON member_first.product_id = menu.product_id
WHERE rnk = 1
ORDER BY customer_id ASC;

##Which item was purchased just before the customer became a member?

WITH member_first AS (
  SELECT me.join_date, me.customer_id, s.order_date, s.product_id,
  ROW_NUMBER() OVER (PARTITION BY me.customer_id ORDER BY s.order_date DESC) AS rnk
  FROM dannys_diner.members me
  INNER JOIN dannys_diner.sales s ON s.customer_id = me.customer_id
  AND s.order_date < me.join_date
)
SELECT customer_id, product_name
FROM member_first
INNER JOIN dannys_diner.menu ON member_first.product_id = menu.product_id
WHERE rnk = 1
ORDER BY customer_id ASC;


##What is the total items and amount spent for each member before they became a member?

SELECT 
  sales.customer_id, 
  COUNT(sales.product_id) AS total_items, 
  SUM(menu.price) AS total_sales
FROM dannys_diner.sales
INNER JOIN dannys_diner.members
  ON sales.customer_id = members.customer_id
  AND sales.order_date < members.join_date
INNER JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY sales.customer_id;


##If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?

WITH menu_price AS (
  SELECT product_id, 
  CASE WHEN product_id = 1 THEN price * 20
  ELSE price * 10 END AS points
  FROM dannys_diner.menu
)
SELECT SUM(m.points) AS total_points, s.customer_id
FROM menu_price m
JOIN dannys_diner.sales s ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

##In the first week after a customer joins the program (including their join date) then earn 2* points 
##all the items not just sushi-how many points do customer A and B have at the end of a january

WITH cte AS (
  SELECT s.customer_id, s.order_date, me.join_date, m.price, m.product_name,
  CASE 
    WHEN product_name = 'sushi' THEN 2 * m.price
    WHEN s.order_date BETWEEN me.join_date AND (me.join_date + INTERVAL '6' DAY) THEN 2 * m.price
    ELSE m.price 
  END AS new_price
  FROM dannys_diner.sales s
  JOIN dannys_diner.members me ON me.customer_id = s.customer_id
  JOIN dannys_diner.menu m ON m.product_id = s.product_id
  WHERE s.order_date <= '2021-01-31'
)
SELECT customer_id, SUM(new_price) * 10 AS total_price
FROM cte
GROUP BY customer_id;

