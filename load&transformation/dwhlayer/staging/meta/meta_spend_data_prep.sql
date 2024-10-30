CREATE TABLE staging.meta_spend_data_prep AS
with spenddata as---removed unwanted column and appended data for 2 campaigns
(
SELECT
date_start,
campaign_id,
campaign_name,
spend
from 
raw.raw_meta_launch_campaign
UNION ALL---2 campaigns data appended
SELECT
date_start,
campaign_id,
campaign_name,
spend
from 
raw.raw_meta_afterwork_campaign
)
Select 
CONCAT_WS('_',date_start,campaign_name) as pk_date_campaign,---identifies unique row
campaign_id,
campaign_name,
spend
from spenddata
