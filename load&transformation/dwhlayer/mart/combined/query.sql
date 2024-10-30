CREATE TABLE mart.fact_marketing_efficiency_daily AS 
SELECT
   pk_date AS pk_date,
   ad_spend,
   count_new_customers,
   count_return_customers,
   gross_merchandise_value,
   discount_value,
   shipping_revenue,
   gross_revenue,
   return_value,
   taxes,
   net_revenue_new,
   net_revenue_return,
   net_revenue 
FROM
   mart.fact_meta_spend_daily AS m 
   LEFT JOIN
      mart.fact_order_daily AS o 
      ON m.pk_date = o.pk_created_at
