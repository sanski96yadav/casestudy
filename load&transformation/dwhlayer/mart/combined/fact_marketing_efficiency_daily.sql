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
   LEFT JOIN --- left joined meta spend table because the aim is to analyze marketing efficiency and therefore all the marketing data should be included
      mart.fact_order_daily AS o 
      ON m.pk_date = o.pk_created_at--- as both the tables have date as common key and we want data on daily level, the 2 tables are joined on date column
