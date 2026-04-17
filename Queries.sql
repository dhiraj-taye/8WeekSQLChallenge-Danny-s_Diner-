/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
    s.customer_id, 
    SUM(m.price) AS total_spent
FROM sales s
JOIN menu m 
    ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_spent DESC;


-- 2. How many days has each customer visited the restaurant?
SELECT 
    customer_id, 
    COUNT(DISTINCT order_date) AS visit_days
FROM sales
GROUP BY customer_id;


-- 3. What was the first item from the menu purchased by each customer?
SELECT 
    t.customer_id, 
    t.order_date, 
    m.product_name
FROM (
    SELECT 
        customer_id,
        order_date,
        product_id,
        RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS rnk
    FROM sales
) t
JOIN menu m
    ON t.product_id = m.product_id
WHERE t.rnk = 1;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
    m.product_name, 
    COUNT(*) AS total_purchase
FROM sales s
JOIN menu m
    ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_purchase DESC
LIMIT 1;


-- 5. Which item was the most popular for each customer?
SELECT 
    customer_id, 
    product_name, 
    order_count
FROM (
    SELECT 
        s.customer_id,
        m.product_name,
        COUNT(*) AS order_count,
        RANK() OVER (
            PARTITION BY s.customer_id 
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM sales s
    JOIN menu m 
        ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
) t
WHERE rnk = 1;


-- 6. Which item was purchased first by the customer after they became a member?
SELECT 
    customer_id, 
    product_name, 
    order_date
FROM (
    SELECT 
        s.customer_id,
        m.product_name,
        s.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id 
            ORDER BY s.order_date
        ) AS rn
    FROM sales s
    JOIN members mem 
        ON s.customer_id = mem.customer_id
    JOIN menu m 
        ON s.product_id = m.product_id
    WHERE s.order_date >= mem.join_date
) t
WHERE rn = 1;


-- 7. Which item was purchased just before the customer became a member?
SELECT 
    customer_id,
    product_name,
    order_date
FROM (
    SELECT 
        s.customer_id,
        m.product_name,
        s.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date DESC
        ) AS rnk
    FROM sales s
    JOIN members mem
        ON s.customer_id = mem.customer_id
    JOIN menu m
        ON s.product_id = m.product_id
    WHERE s.order_date < mem.join_date
) t
WHERE rnk = 1;


-- 8. What is the total items and amount spent for each member before they became a member?
SELECT 
    s.customer_id, 
    COUNT(*) AS total_items,
    SUM(m.price) AS total_spent
FROM sales s
JOIN members mem
    ON s.customer_id = mem.customer_id
JOIN menu m
    ON s.product_id = m.product_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id
ORDER BY total_spent;


-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT 
    s.customer_id,
    SUM(
        CASE 
            WHEN m.product_name = 'sushi' THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS total_points
FROM sales s
JOIN menu m
    ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_points DESC;


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT 
    s.customer_id,
    SUM(
        CASE
            WHEN s.order_date BETWEEN mem.join_date AND DATE_ADD(mem.join_date, INTERVAL 6 DAY)
                THEN m.price * 20
            WHEN m.product_name = 'sushi'
                THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS total_points
FROM sales s
JOIN members mem
    ON s.customer_id = mem.customer_id
JOIN menu m
    ON s.product_id = m.product_id
WHERE s.order_date <= '2021-01-31'
GROUP BY s.customer_id
ORDER BY s.customer_id;