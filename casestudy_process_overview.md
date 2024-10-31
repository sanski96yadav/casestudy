# casestudy process overview

The casestudy is divided into three main following parts and each part is further divided into Meta and Shopify:

* ```extraction```
* ```load&transformation```
* ```visualization```

```extraction```: 
* In the extraction part, the Meta and Shopify data is fetched from the respective sources. Meta data is extracted from Insights API through Python based on the access token and ad account ID provided. Python libraries like requests, pandas, psycopg2 and csv were used to carry out the extraction
* Meta data was extracted on campaign level using campaign ids, ```campaign id/insights```. Campaigns ids were extracted using ```ad account id/ campaigns```. It was done on campaign level, as on account id level the data fetched was not complete
* 2 campaign ids were fetched representing launch and afterwork campaigns. Hence, Meta data was extracted in 2 parts for 2 campaigns
* Data is available for launch campaign from 4th May 2024 to 31st July 2024 and for afterwork campaign from 3rd June 2024 to 13th June 2024
* The sum of impressions and spend for data extracted was cross-checked with the output received from ```ad account id/insights?&date_preset=maximum```
* Shopify data was available in csv file and the file was uploaded into PostgreSQL
* The file had 157 columns and not all columns were needed so many columns were deleted before uploading the file
* Shopify data is available from 3rd May 2024 to 5th August 2024

```load&transformation```: 
* Meta data was loaded into PostgreSQL RDBMS using psycopg2 library in Python that connects to PostgreSQL
* Shopify data was loaded by importing csv file through PostgreSQL interface
* Meta and Shopify data was transformed in 3 layers, ```raw, staging, mart``` and data moves from raw layer to staging and staging to mart
* The tables in mart layer are created based on use case given and further used in Power BI
* In ```raw layer```, data is kept as it is only constraints and pri key are assigned
* In ```staging layer```, raw data goes under different transformations like change in data type, extraction of values in usable form, creation of calculated columns, appending of data
*  Meta data for 2 campaigns stored in 2 raw tables is appended in this stage
*  Shopify data is prepared to give columns like gross revenue, discounts, taxes, return value, shipping price, net revenue based on [KLAR's logic](https://help.getklar.com/en/articles/6127409-revenue-defintion-klar-vs-shopify)
