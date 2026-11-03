-- 1. Monthly order trend
SELECT
  DATE_TRUNC(order_date, MONTH) AS order_month,
  COUNT(*) AS total_orders,
  COUNTIF(LOWER(order_status) = 'delivered') AS delivered_orders,
  COUNTIF(LOWER(order_status) = 'cancelled') AS cancelled_orders
FROM `your-project-id.ecommerce_analysis.orders`
GROUP BY order_month
ORDER BY order_month;

-- 2. Month-over-month order growth
WITH monthly_orders AS (
  SELECT
    DATE_TRUNC(order_date, MONTH) AS order_month,
    COUNT(*) AS total_orders
  FROM `your-project-id.ecommerce_analysis.orders`
  GROUP BY order_month
)
SELECT
  order_month,
  total_orders,
  LAG(total_orders) OVER (ORDER BY order_month) AS previous_month_orders,
  ROUND(
    SAFE_DIVIDE(
      total_orders - LAG(total_orders) OVER (ORDER BY order_month),
      LAG(total_orders) OVER (ORDER BY order_month)
    ) * 100, 2
  ) AS mom_growth_pct
FROM monthly_orders
ORDER BY order_month;

-- 3. Day-of-week analysis
SELECT
  FORMAT_DATE('%A', order_date) AS weekday,
  EXTRACT(DAYOFWEEK FROM order_date) AS weekday_number,
  COUNT(*) AS total_orders
FROM `your-project-id.ecommerce_analysis.orders`
GROUP BY weekday, weekday_number
ORDER BY weekday_number;

-- 4. Quarterly order volume
SELECT
  EXTRACT(YEAR FROM order_date) AS order_year,
  EXTRACT(QUARTER FROM order_date) AS order_quarter,
  COUNT(*) AS total_orders
FROM `your-project-id.ecommerce_analysis.orders`
GROUP BY order_year, order_quarter
ORDER BY order_year, order_quarter;
