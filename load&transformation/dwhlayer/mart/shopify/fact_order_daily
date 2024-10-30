CREATE TABLE mart.fact_order_daily AS 
WITH newcustlogic AS 
(
   SELECT
      created_at AS pk_created_at,
      COUNT(
      CASE
         WHEN
            customer_type = 'new customer' 
         THEN
            customer_id 
      END
) AS count_new_customers,---FOR CAC CALCULATION
      COUNT(
      CASE
         WHEN
            customer_type = 'return customer' 
         THEN
            customer_id 
      END
) AS count_return_customers, 
SUM(gross_merchandise_value) AS gross_merchandise_value, 
SUM(discount) AS discount_value, SUM(shipping) AS shipping_revenue,
SUM(gross_revenue) AS gross_revenue, SUM(return_value) AS return_value, 
SUM(taxes) AS taxes, 
SUM(
      CASE
         WHEN
            customer_type = 'new customer' 
         THEN
            gross_revenue - return_value - taxes 
      END
) AS net_revenue_new_customers,---FOR MER CALCULATION
      SUM(
      CASE
         WHEN
            customer_type = 'return customer' 
         THEN
            gross_revenue - return_value - taxes 
      END
) AS net_revenue_return_customers,---FOR aMER CALCULATION
SUM(gross_revenue - return_value - taxes) AS net_revenue--- BASED ON KLAR LOGIC
   FROM
      staging.shopify_order_data_prep 
   GROUP BY
      1 
)
, replacenull AS 
(
   SELECT
      pk_created_at,
      count_new_customers,
      count_return_customers,
      gross_merchandise_value,
      discount_value,
      shipping_revenue,
      gross_revenue,
      return_value,
      taxes,
      CASE
         WHEN
            net_revenue_new_customers IS NULL 
         THEN
            0 
         ELSE
            net_revenue_new_customers 
      END
      AS net_revenue_new, 
      CASE
         WHEN
            net_revenue_return_customers IS NULL 
         THEN
            0 
         ELSE
            net_revenue_return_customers 
     END
     AS net_revenue_return, 
     net_revenue 
   FROM
      newcustlogic 
)
SELECT
   * 
FROM
   replacenull
