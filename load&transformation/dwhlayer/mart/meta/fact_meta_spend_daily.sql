CREATE TABLE mart.fact_meta_spend_daily AS 
SELECT
   date AS pk_date,
   SUM(spend) AS ad_spend 
FROM
   staging.meta_spend_data_prep
GROUP BY
   1
