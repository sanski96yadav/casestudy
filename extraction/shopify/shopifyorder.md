## Notes: ##


Steps carried out to extract shopify data:

* The csv file provided was downloaded and saved on local machine
* It had 157 columns and based on use case given, not at all columns were of use, so unwanted columns were removed from csv file. The file was then saved on local machine
* Based on the columns in file, table schema was created in PostgreSQL by entering column names and their datatypes
* The data from csv file was loaded in the table in PostgreSQL through interface ```Right click 'Table'> Create> Table> Enter column name in 'Name'> Enter column names under 'Columns'> Enter respective datatpes> Save```
