CREATE TABLE raw.raw_meta_afterwork_campaign (
    account_currency TEXT,
    account_name TEXT,
    campaign_id BIGINT,
    campaign_name TEXT,
    clicks INTEGER,
    date_start DATE NOT NULL PRIMARY KEY,
    date_stop DATE,
    impressions INTEGER,
    spend NUMERIC
);
