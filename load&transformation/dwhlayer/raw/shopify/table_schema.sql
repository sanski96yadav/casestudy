CREATE TABLE raw.raw_shopify_order (
    created_at DATE NOT NULL,
    customer_created_at DATE,
    customer_id BIGINT,
    discount_application_target_type TEXT,
    discount_application_value TEXT,
    discount_application_value_type TEXT,
    discount_code_type TEXT,
    financial_status TEXT,
    id BIGINT NOT NULL UNIQUE PRIMARY KEY,
    landing_site TEXT,
    line_item_price TEXT,
    line_item_quantity TEXT,
    line_item_tax_lines_price TEXT,
    referring_site TEXT,
    refund_transactions_amount TEXT,
	shipping_line_price TEXT,
    total_discounts NUMERIC,
    total_line_items_price NUMERIC,
    total_price NUMERIC,
    total_shipping_price NUMERIC,
    total_subtotal_price NUMERIC,
    total_tax NUMERIC
);