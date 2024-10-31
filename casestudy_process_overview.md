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
