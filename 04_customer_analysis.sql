-- 1. Top 10 customers by number of orders
SELECT
  customer_id,
  COUNT(*) AS total_orders,
  COUNTIF(LOWER(order_status) = 'delivered') AS delivered_orders,
  COUNTIF(LOWER(order_status) = 'cancelled') AS cancelled_orders
FROM `your-project-id.ecommerce_analysis.orders`
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- 2. Repeat customers (more than one order)
SELECT
  customer_id,
  COUNT(*) AS total_orders,
  MIN(order_date) AS first_order_date,
  MAX(order_date) AS latest_order_date
FROM `your-project-id.ecommerce_analysis.orders`
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;

-- 3. Customer order activity segment
WITH customer_summary AS (
  SELECT
    customer_id,
    COUNT(*) AS total_orders,
    COUNTIF(LOWER(order_status) = 'delivered') AS delivered_orders,
    COUNTIF(LOWER(order_status) = 'cancelled') AS cancelled_orders
  FROM `your-project-id.ecommerce_analysis.orders`
  GROUP BY customer_id
)
SELECT
  *,
  CASE
    WHEN total_orders >= 5 THEN 'Highly Active'
    WHEN total_orders BETWEEN 2 AND 4 THEN 'Repeat Customer'
    ELSE 'One-time Customer'
  END AS customer_segment
FROM customer_summary
ORDER BY total_orders DESC;

-- 4. Customers with the most cancellations
SELECT
  customer_id,
  COUNT(*) AS cancelled_orders
FROM `your-project-id.ecommerce_analysis.orders`
WHERE LOWER(order_status) = 'cancelled'
GROUP BY customer_id
ORDER BY cancelled_orders DESC, customer_id
LIMIT 10;
