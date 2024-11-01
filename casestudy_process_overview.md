# casestudy process overview

The casestudy is divided into three main following parts and each part is further divided into Meta and Shopify:

* ```extraction```
* ```load&transformation```
* ```visualization```

```extraction```: 
* In the extraction part, the Meta and Shopify data is fetched from the respective sources. Meta data is extracted from Insights API through Python based on the access token and ad account ID provided. Python libraries like requests, pandas, psycopg2 and csv were used to carry out the extraction
* Meta data was extracted on campaign level using campaign ids, ```{campaignid}/insights```. Campaigns ids were extracted using ```{adaccountid}/campaigns?field=id,name```. It was done on campaign level, as on account id level the data fetched was not complete
* 2 campaign ids were fetched representing launch and afterwork campaigns. Hence, Meta data was extracted in 2 parts for 2 campaigns
* Data is available for launch campaign from 4th May 2024 to 31st July 2024 and for afterwork campaign from 3rd June 2024 to 13th June 2024
* The sum of impressions and spend for data extracted was cross-checked with the output received from ```{adaccountid}/insights?&date_preset=maximum```. ```date_preset=maximun``` returns data for entire history and therefore, its output is used for cross-validation
* Shopify data was available in csv file and the file was uploaded into PostgreSQL
* The file had 157 columns and not all columns were needed so many columns were deleted before uploading the file
* Shopify data is available from 3rd May 2024 to 5th August 2024


```load&transformation```: 
* Meta data was loaded into PostgreSQL RDBMS using psycopg2 library in Python that connects to PostgreSQL
* Shopify data was loaded by importing csv file through PostgreSQL interface
* The columns in both Meta and Shopify data were understood by referring to the [Insights API](https://developers.facebook.com/docs/marketing-api/reference/ad-account/insights) and [Shopify](https://help.shopify.com/en/manual/fulfillment/managing-orders/exporting-orders) documentation respectively 
* Meta and Shopify data was transformed in 3 layers, ```raw, staging, mart``` and data moves from raw layer to staging and staging to mart
* The tables in mart layer are created based on use case given and further used in Power BI
* In ```raw layer```, data is kept as it is only constraints and pri key are assigned
* In ```staging layer```, raw data goes under different transformations like change in data type, extraction of values in usable form, creation of calculated columns, appending of data
*  Meta data for 2 campaigns stored in 2 raw tables is appended in this stage
*  Shopify data is prepared to give columns like gross revenue, discounts, taxes, return value, shipping price, net revenue based on the logic that company follows (shared on company's website)
* In ```mart layer``` the respective periodic snapshots fact tables (daily level) for Meta and Shopify data were created by aggregation of data. Both the data was also merged in this layer using date column, as date is the common field and also we want to have daily overview in dashboard
* Fact table for Meta data was left joined to the fact table for Shopify data, as aim is to analyze marketing performance. Left join will ensure complete marketing data is included after merge
* Based on the use case and nature of the fact table needed i.e. periodic snapshot one, dimension tables (dim tables) for campaigns, cities, ad names were not created
* In case dim tables were created, star schema would have been preferred as it is good for read performance


```visualization```:
* The merged fact table (meta + shopify) was added in Power BI through exporting csv file from PostgreSQL and importing it in Power BI. Direct connection to PostgreSQL was throwing an error
* The fact table was then joined with ```dim date``` table in Power BI to present the KPIs wrt to dim date table columns. ```dim date``` table was created in Power BI itself
* KPIs like CAC, MER, Adjusted MER (aMER) and their %MoM, %DoD were calculated in Power BI using DAX
* Adjusted MER was assumed as Acquisition MER
* MER & aMER were calculated on Net Revenue. Discounts, returns, taxes, shipping price were taken care of in calculation of Net Revenue
* The 3 KPIs are displayed in cards with benchmark as %MoM to give quick summary
* Further, 3 KPIs are displayed on daily level for monitoring and understanding daily performance. As the date level was needed, the line graph is most suitable to showcase KPIs over time
* In line graph, secondary line for ```target``` is provided again for benchmark. ```target``` values are random and not calculated from data
* As 3 KPIs, are based on sub KPIs like Ad Spend, Net Revenue,No. of new customers, it is always useful to showcase them for further deep dive and understand what's happening, hence, tabular view is provided 
