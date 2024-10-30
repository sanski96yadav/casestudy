## Notes: ##

Description of how raw_meta_campaign table is created in raw layer of PostgreSQL DWH:
* The extracted data from Insights API has been loaded into PostgreSQL through Python using campaign id and access token
* Campaign ids was fetched using ad account id. As data fetched on ad account id level was not giving complete data (cross-checked with o/p of 'meta_data_summary.py' file), the data was extracted on campaign level
* Before loading the data in PostgreSQL, the table schema was created through the interface by inputting column names and their datatypes in order
