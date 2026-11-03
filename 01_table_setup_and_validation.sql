-- E-COMMERCE ORDERS PROJECT
-- Replace your-project-id with your Google Cloud project ID.
-- Create the table if you prefer to create it through SQL.
CREATE TABLE IF NOT EXISTS `your-project-id.ecommerce_analysis.orders` (
  order_id INT64,
  customer_id INT64,
  order_date DATE,
  order_status STRING,
  payment_method STRING
);

-- After loading your 150-row CSV, validate row count and sample records.
SELECT COUNT(*) AS total_rows
FROM `your-project-id.ecommerce_analysis.orders`;

SELECT *
FROM `your-project-id.ecommerce_analysis.orders`
ORDER BY order_id
LIMIT 10;

-- Check duplicate order IDs (expect no rows).
SELECT order_id, COUNT(*) AS records
FROM `your-project-id.ecommerce_analysis.orders`
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check null values.
SELECT
  COUNTIF(order_id IS NULL) AS null_order_id,
  COUNTIF(customer_id IS NULL) AS null_customer_id,
  COUNTIF(order_date IS NULL) AS null_order_date,
  COUNTIF(order_status IS NULL) AS null_order_status,
  COUNTIF(payment_method IS NULL) AS null_payment_method
FROM `your-project-id.ecommerce_analysis.orders`;

-- Check distinct category values.
SELECT DISTINCT order_status
FROM `your-project-id.ecommerce_analysis.orders`
ORDER BY order_status;

SELECT DISTINCT payment_method
FROM `your-project-id.ecommerce_analysis.orders`
ORDER BY payment_method;
