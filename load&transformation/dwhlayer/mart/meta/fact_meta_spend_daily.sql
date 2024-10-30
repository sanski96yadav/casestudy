CREATE TABLE mart.fact_meta_spend_daily AS 
SELECT
   date_start AS pk_date,
   SUM(spend) AS ad_spend 
FROM
   raw.raw_meta_campaign 
GROUP BY
   1
