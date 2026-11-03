-- 1. Latest order for every customer
SELECT *
FROM `ecommerce-sql-project-513607.ecommerce_analysis.orders`
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY customer_id
  ORDER BY order_date DESC, order_id DESC
) = 1;

-- 2. Previous order date and days between orders for each customer
SELECT
  customer_id,
  order_id,
  order_date,
  LAG(order_date) OVER (
    PARTITION BY customer_id
    ORDER BY order_date, order_id
  ) AS previous_order_date,
  DATE_DIFF(
    order_date,
    LAG(order_date) OVER (
      PARTITION BY customer_id
      ORDER BY order_date, order_id
    ),
    DAY
  ) AS days_since_previous_order
FROM `ecommerce-sql-project-513607.ecommerce_analysis.orders`
ORDER BY customer_id, order_date;

-- 3. Rank customers by order count
WITH customer_orders AS (
  SELECT customer_id, COUNT(*) AS total_orders
  FROM `ecommerce-sql-project-513607.ecommerce_analysis.orders`
  GROUP BY customer_id
)
SELECT
  customer_id,
  total_orders,
  DENSE_RANK() OVER (ORDER BY total_orders DESC) AS customer_rank
FROM customer_orders
ORDER BY customer_rank, customer_id;

-- 4. Monthly cancellation rate
SELECT
  DATE_TRUNC(order_date, MONTH) AS order_month,
  COUNT(*) AS total_orders,
  COUNTIF(LOWER(order_status) = 'cancelled') AS cancelled_orders,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(LOWER(order_status) = 'cancelled'),
      COUNT(*)
    ) * 100, 2
  ) AS cancellation_rate_pct
FROM `ecommerce-sql-project-513607.ecommerce_analysis.orders`
GROUP BY order_month
ORDER BY order_month;

-- PRACTICE CHALLENGES: solve these without looking up solutions.
-- 1. Find the customer with the highest number of delivered orders.
-- 2. Find the month with the highest number of cancelled orders.
-- 3. Find the most frequently used payment method in each year.
-- 4. Find customers who placed orders in both 2024 and 2025.
-- 5. Find customers whose every order is Delivered.
-- 6. Find the longest gap between two consecutive orders for each customer.
-- 7. Calculate each payment method's percentage of all orders.
-- 8. Rank months by total order count within each year.
-- 9. Find the cancellation percentage for each year.
-- 10. Create a view named vw_order_summary with customer, date, status and payment details.
