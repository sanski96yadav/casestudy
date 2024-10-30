## Notes: ##

Description of how raw_shopify_order table is created in raw layer of PostgreSQL DWH:
* The data was already extracted and available in csv file
* The csv file was uploaded to the PostgreSQL from local machine
* Before loading the data, the table schema was created through the interface by inputing column names and their datatypes in order
* 'id' i.e. order id column was assigned as primary key and 'not null' & 'unique' constraint was applied
