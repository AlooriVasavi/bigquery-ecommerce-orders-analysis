-- 1. Most popular payment methods
SELECT
  payment_method,
  COUNT(*) AS total_orders,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM `ecommerce-sql-project-513607.ecommerce_analysis.orders`
GROUP BY payment_method
ORDER BY total_orders DESC;

-- 2. Payment method by order status
SELECT
  payment_method,
  COUNTIF(LOWER(order_status) = 'delivered') AS delivered,
  COUNTIF(LOWER(order_status) = 'cancelled') AS cancelled,
  COUNTIF(LOWER(order_status) = 'shipped') AS shipped,
  COUNTIF(LOWER(order_status) = 'processing') AS processing,
  COUNT(*) AS total_orders
FROM `ecommerce-sql-project-513607.ecommerce_analysis.orders`
GROUP BY payment_method
ORDER BY total_orders DESC;

-- 3. Cancellation rate by payment method
SELECT
  payment_method,
  COUNT(*) AS total_orders,
  COUNTIF(LOWER(order_status) = 'cancelled') AS cancelled_orders,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(LOWER(order_status) = 'cancelled'),
      COUNT(*)
    ) * 100, 2
  ) AS cancellation_rate_pct
FROM `ecommerce-sql-project-513607.ecommerce_analysis.orders`
GROUP BY payment_method
ORDER BY cancellation_rate_pct DESC;

-- 4. Payment method ranking
SELECT
  payment_method,
  COUNT(*) AS total_orders,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS payment_rank
FROM `ecommerce-sql-project-513607.ecommerce_analysis.orders`
GROUP BY payment_method;
