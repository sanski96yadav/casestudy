CREATE TABLE staging.shopify_order_data_prep AS
with extract_value AS ---CTE TO EXTRACT COL VALUES IN USABLE FORM
(
   SELECT
      created_at,
      customer_id,
      financial_status,
      LAG(created_at) OVER (PARTITION BY customer_id 
   ORDER BY
      created_at) as prev_order,--- TO IDENTIFY RETURN CUSTOMER AS RETURN CUSTOMER WILL HAVE MORE THAN 1 CREATED AT DATE
      SUBSTRING(discount_code_type FROM '([a-zA-Z_]+)') AS discount_code_type,--- TO EXTRACT VALUES FROM LIST BASED ON PATTERN, ONE OR MORE ALPHABETS (SMALL OR CAP) AND UNDERSCORES
      SUBSTRING(discount_application_value FROM '([0-9]+(\.[0-9]+)?)') AS discount_application_value,--- TO EXTRACT VALUES FROM LIST BASED ON PATTERN, ONE OR MORE DIGITS FORMING INTEGERS OR DECIMAL NUMBERS. (\.[0-9]+)? IS OPTIONAL TO MATCH DECIMAL NUMBERS AS NOT ALL VALUES ARE INTEGERS IN COLUMN 
      SUBSTRING(discount_application_value_type FROM '([a-zA-Z_]+)') AS discount_application_value_type,--- TO EXTRACT VALUES FROM LIST BASED ON PATTERN, ONE OR MORE ALPHABETS (SMALL OR CAP) AND UNDERSCORES
      SPLIT_PART(REPLACE(REPLACE(line_item_price, '[', ''), ']', ''), ',', 1) AS line_item1_price, ---FIRST REMOVES OPENING SQUARE BRACKET THEN CLOSING ONE, AS REPLACEMENT STRING IS EMPTY. THEN SPLIT THE STRING BY COMMA AND OUTPUT IS FIRST PART OF THE SPLIT
      TRIM(SPLIT_PART(REPLACE(REPLACE(line_item_price, '[', ''), ']', ''), ',', 2)) AS line_item2_price,--- SAME AS ABOVE BUT OUTPUT IS SECOND PART OF THE STRING i.e. AFTER COMMA. TRIM IS USED TO REMOVE SPACE AFTER COMMA AND BEFORE FIRST DIGIT
      SPLIT_PART(REPLACE(REPLACE(line_item_quantity, '[', ''), ']', ''), ',', 1) AS line_item1_quantity,---FIRST REMOVES OPENING SQUARE BRACKET THEN CLOSING ONE, AS REPLACEMENT STRING IS EMPTY. THEN SPLIT THE STRING BY COMMA AND OUTPUT IS FIRST PART OF THE SPLIT
      TRIM(SPLIT_PART(REPLACE(REPLACE(line_item_quantity, '[', ''), ']', ''), ',', 2)) AS line_item2_quantity,--- SAME AS ABOVE BUT OUTPUT IS SECOND PART OF THE STRING i.e. AFTER COMMA. TRIM IS USED TO REMOVE SPACE AFTER COMMA AND BEFORE FIRST DIGIT
      SUBSTRING(shipping_line_price FROM '([0-9]+\.[0-9]+?)') AS shipping_line_price,--- TO EXTRACT VALUES FROM LIST BASED ON PATTERN, ONE OR MORE DIGITS FORMING INTEGERS OR DECIMAL NUMBERS. (\.[0-9]+)? IS OPTIONAL TO MATCH DECIMAL NUMBERS AS NOT ALL VALUES ARE INTEGERS IN COLUMN
      REPLACE(REPLACE(refund_transactions_amount, '[', ''), ']', '') AS refund_amount ---FIRST REMOVES 2 OPENING SQUARE BRACKET THEN 2 CLOSING ONES, AS REPLACEMENT STRING IS EMPTY
   FROM
      raw.raw_shopify_order 
   WHERE
      financial_status <> 'voided' 
)
,
customer_and_blank AS ---CTE TO CATEGORIZE CUST & DEAL WITH BLANK VALUES IN COL 
(
   SELECT
      created_at,
      customer_id,
      financial_status,
      discount_code_type,
      discount_application_value,
      discount_application_value_type,
      shipping_line_price,
      line_item1_price AS unit_price_item1,
      line_item1_quantity AS quantity_item1,
      CASE
         WHEN
            line_item2_price = '' 
         THEN
            NULL 
         ELSE
            line_item2_price 
      END
      AS unit_price_item2,--- TO REPLACE BLANK WITH NULL. NOT ALWAYS 'line_item_price' COL HAS SECOND STRING SO THERE ARE BLANK VALUES IN 'line_item2_price' COL AND THESE VALUES WILL NOT ALLOW TO CONVERT COL TO NUMERIC DATATYPE IN FURTHER STEPS
      CASE
         WHEN
            line_item2_quantity = '' 
         THEN
            NULL 
         ELSE
            line_item2_quantity 
      END
      AS quantity_item2,--- TO REPLACE BLANK WITH NULL. NOT ALWAYS 'line_item_quantity' COL HAS SECOND STRING SO THERE ARE BLANK VALUES IN 'line_item2_quantity' COL AND THESE VALUES WILL NOT ALLOW TO CONVERT COL TO NUMERIC DATATYPE IN FURTHER STEPS
      CASE
         WHEN
            refund_amount = '' 
         THEN
            NULL 
         ELSE
            refund_amount 
      END
      AS refund, --- TO REPLACE BLANK WITH NULL. THERE ARE BLANK VALUES IN COL AND THESE VALUES WILL NOT ALLOW TO CONVERT COL TO NUMERIC DATATYPE IN FURTHER STEPS
      CASE
         WHEN
            prev_order is null 
         THEN
            'new customer' 
        ELSE
            'return customer' 
      END
      AS customer_type --- IF CUST HAS ORDERED IN PAST THEN RETURN CUST ELSE NEW CUST
   FROM
      extract_value 
)
, datatypes AS 
(
   SELECT
      created_at,
      customer_id,
      financial_status,
      customer_type,
      discount_code_type,
      discount_application_value_type,
      CAST (discount_application_value AS numeric),
      CAST (shipping_line_price AS numeric),
      CAST (unit_price_item1 AS numeric),
      CAST (quantity_item1 AS integer),
      CAST (unit_price_item2 AS numeric),
      CAST (quantity_item2 AS integer),
      CAST (refund AS numeric) 
   from
      customer_and_blank 
)
,
nulltozero AS  
(
   SELECT
      created_at,
      customer_id,
      financial_status,
      customer_type,
      discount_code_type,
      discount_application_value_type,
      discount_application_value,
      unit_price_item1 AS unit_price_item_1,
      quantity_item1 AS quantity_item_1,
      CASE
         WHEN
            unit_price_item2 IS NULL 
         THEN
            0 
         ELSE
            unit_price_item2 
      END
      AS unit_price_item_2, 
      CASE
         WHEN
            quantity_item2 IS NULL 
         THEN
            0 
         ELSE
            quantity_item2 
      END
      AS quantity_item_2, 
      CASE
         WHEN
            shipping_line_price IS NULL 
         THEN
            0 
         ELSE
            shipping_line_price 
      END
      AS shipping_price, 
      CASE
         WHEN
            refund IS NULL 
         THEN
            0 
         ELSE
            refund 
      END
      AS refund_value 
   FROM
      datatypes 
)
, calculation AS  
(
   SELECT
      created_at,
      customer_id,
      financial_status,
      customer_type,
      discount_code_type,
      discount_application_value_type,
      discount_application_value,
      (
         unit_price_item_1*quantity_item_1
      )
       + (unit_price_item_2*quantity_item_2) AS order_amount,
      CASE
         WHEN
            discount_code_type = 'shipping' 
         THEN
            0 
         ELSE
            shipping_price 
      END
      AS shipping, refund_value 		--total_tax
   FROM
      nulltozero 
)
, discountvalues AS  
(
   SELECT
      created_at,
      customer_id,
      financial_status,
      customer_type,
      discount_code_type,
      discount_application_value_type,
      discount_application_value,
      CASE
         WHEN
            discount_application_value_type = 'fixed_amount' 
         THEN
            discount_application_value 
         WHEN
            discount_application_value_type = 'percentage' 
            AND discount_code_type <> 'shipping' 
         THEN
            round((discount_application_value / 100)*order_amount, 2) 
         ELSE
            0 
      END
      AS discount, order_amount, shipping, refund_value 
   FROM
      calculation 
)
, revenuecalc AS  
(
   SELECT
      created_at,
      customer_id,
      financial_status,
      customer_type,
      order_amount AS gross_merchandise_value,
      discount,
      shipping,
      (
         order_amount - discount + shipping
      )
      AS gross_revenue,
      CASE
         WHEN
            financial_status = 'refunded' 
         THEN
(order_amount - discount + shipping) 
         WHEN
            financial_status = 'partially_refunded'
         THEN
            refund_value 
         ELSE
            0 
      END
      AS return_value 		--case when financial_status<>'refunded' then total_tax else 0 end as taxes
   FROM
      discountvalues 
)
, tax_calc AS  
(
   SELECT
      *,
      CASE
         WHEN
            financial_status = 'refunded' 
         THEN
            0 
         WHEN
            financial_status = 'partially_refunded' 
         THEN
            round((gross_revenue - return_value) - ((gross_revenue - return_value) / 1.19), 2) 
         ELSE
            round(gross_revenue - (gross_revenue / 1.19), 2) 
      END
      AS taxes 
   FROM
      revenuecalc 
)
SELECT
   CONCAT_WS('_', created_at, customer_id) AS pk_shopify_order,
   created_at,
   customer_id,
   financial_status,
   customer_type,
   gross_merchandise_value,
   discount,
   shipping,
   gross_revenue,
   return_value,
   taxes 
FROM
   tax_calc
