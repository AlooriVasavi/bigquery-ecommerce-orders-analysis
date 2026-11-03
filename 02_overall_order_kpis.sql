-- 1. Overall business KPIs
SELECT
  COUNT(*) AS total_orders,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNTIF(LOWER(order_status) = 'delivered') AS delivered_orders,
  COUNTIF(LOWER(order_status) = 'cancelled') AS cancelled_orders,
  COUNTIF(LOWER(order_status) = 'shipped') AS shipped_orders,
  COUNTIF(LOWER(order_status) = 'processing') AS processing_orders,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(LOWER(order_status) = 'cancelled'),
      COUNT(*)
    ) * 100, 2
  ) AS cancellation_rate_pct
FROM `your-project-id.ecommerce_analysis.orders`;

-- 2. Order status distribution
SELECT
  order_status,
  COUNT(*) AS order_count,
  ROUND(SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER()) * 100, 2)
    AS order_share_pct
FROM `your-project-id.ecommerce_analysis.orders`
GROUP BY order_status
ORDER BY order_count DESC;

-- 3. Orders by year
SELECT
  EXTRACT(YEAR FROM order_date) AS order_year,
  COUNT(*) AS total_orders,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM `your-project-id.ecommerce_analysis.orders`
GROUP BY order_year
ORDER BY order_year;
