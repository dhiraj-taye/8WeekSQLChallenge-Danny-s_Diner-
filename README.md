# Danny's Diner SQL Case Study

This repository contains my solution to **Case Study #1 - Danny's Diner** from the **8 Week SQL Challenge** by Danny Ma.

The goal of this case study is to analyze customer purchase behavior, menu preferences, visit patterns, and loyalty program impact using SQL. The case study includes 3 datasets: `sales`, `menu`, and `members`. :contentReference[oaicite:1]{index=1}

## Problem Statement

Danny wants to use customer data to answer important business questions such as:

- How much each customer spent
- How often customers visited
- Which menu items were most popular
- How the loyalty program affected customer behavior

These insights can help improve customer experience and support decisions around expanding the loyalty program. :contentReference[oaicite:2]{index=2}

## Dataset Overview

The case study uses 3 tables:

### 1. `sales`
Captures customer-level purchases with:
- `customer_id`
- `order_date`
- `product_id`

### 2. `menu`
Maps each `product_id` to:
- `product_name`
- `price`

### 3. `members`
Stores the loyalty program join date for each customer:
- `customer_id`
- `join_date`

These tables and their structure are defined in the official case study. :contentReference[oaicite:3]{index=3}

## Tools Used

- MySQL 8+
- DB Fiddle / SQL editor
- GitHub for documentation and version control

## SQL Concepts Used

This project helped me practice:

- `JOINS`
- `GROUP BY` and aggregate functions
- `COUNT`, `SUM`
- `CASE WHEN`
- Window functions like `RANK()` and `ROW_NUMBER()`
- Date-based filtering
- Business logic translation into SQL

These topics align closely with the skills emphasized in the case study and its learning focus. :contentReference[oaicite:4]{index=4}

---

# Case Study Questions and Approach

## 1. What is the total amount each customer spent at the restaurant?

### Approach
I joined the `sales` and `menu` tables using `product_id` so I could access the price of each ordered item. Then I used `SUM(price)` and grouped by `customer_id` to calculate the total amount spent by each customer.

---

## 2. How many days has each customer visited the restaurant?

### Approach
A customer can place multiple orders on the same day, so I used `COUNT(DISTINCT order_date)` to count unique visit days instead of total orders. Then I grouped the result by `customer_id`.

---

## 3. What was the first item from the menu purchased by each customer?

### Approach
To find each customer’s first purchase, I ranked orders by `order_date` using a window function partitioned by `customer_id`. Then I filtered only the first-ranked rows and joined with the `menu` table to get the product name.

---

## 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

### Approach
I joined `sales` with `menu`, grouped by `product_name`, and counted how many times each item appeared in the sales table. Then I sorted the result in descending order and selected the top item.

---

## 5. Which item was the most popular for each customer?

### Approach
I first counted how many times each customer ordered each item using `GROUP BY customer_id, product_name`. Then I used `RANK()` partitioned by customer to identify the highest-frequency item for each customer.

---

## 6. Which item was purchased first by the customer after they became a member?

### Approach
I joined the `sales`, `members`, and `menu` tables, filtered orders that happened on or after the membership join date, and used `ROW_NUMBER()` to rank purchases by date for each customer. Then I selected the first purchase after membership.

---

## 7. Which item was purchased just before the customer became a member?

### Approach
I filtered only the orders placed before the membership join date. Then I ranked those purchases in descending order of `order_date` for each customer and selected the most recent one before membership.

---

## 8. What is the total items and amount spent for each member before they became a member?

### Approach
I filtered transactions before the join date, then grouped by `customer_id`. I used:
- `COUNT(*)` to get total number of items purchased
- `SUM(price)` to calculate total amount spent

---

## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

### Approach
I used a `CASE WHEN` statement to apply different point rules:
- Sushi: `price * 20`
- All other items: `price * 10`

Then I summed the calculated points for each customer.

---

## 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

### Approach
This question required combining date logic and points logic.

I used a `CASE WHEN` statement to apply:
- 2x points to **all items** during the first 7 days from each customer’s join date
- outside that period, only sushi received 2x points
- all other items received normal points

I also filtered data only up to **2021-01-31** because the question specifically asks for points at the end of January. The official case study defines this first-week double-points rule and asks for the January-end totals for customers A and B. :contentReference[oaicite:5]{index=5}

---

# Key Learnings

This case study helped me understand that SQL is not just about writing queries — it is about solving business problems with data.

Some of the main things I improved through this project:

- Translating business questions into SQL logic
- Deciding when to use aggregation vs window functions
- Handling customer-level and product-level analysis
- Applying conditional business rules using `CASE`
- Working with date filters and membership logic

---

# Files in This Repository

- `dannys_diner_setup.sql` → schema and sample data
- `dannys_diner_solutions.sql` → solutions for all 10 case study questions
- `README.md` → project overview and explanation

---

# Source

This project is based on **Case Study #1 - Danny's Diner** from the **8 Week SQL Challenge** by Danny Ma. The official page includes the business context, table descriptions, case study questions, and bonus tasks. :contentReference[oaicite:6]{index=6}

Original case study: [8 Week SQL Challenge - Danny's Diner](https://8weeksqlchallenge.com/case-study-1/)

---

# Final Note

This was a great hands-on SQL case study for practicing real business-style analysis using joins, aggregations, ranking, and conditional logic. It gave me a much better understanding of how SQL can be used to generate customer and product insights from transactional data.
