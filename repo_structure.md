# casestudy

The casestudy folder consists of three main folders and their sub-folders. All the main folders are further divided into ```meta``` and ```shopify```

Three main folders:

* ```extraction:``` This folder provides Python codes used for extracting data from Insights API for meta data. Shopify data was not extracted, as it was provided in csv file already
  
* ```load&transformation:``` This folder is divided into subfolders according to DWH layers in ```klar database```, ```raw > staging > mart```. Subfolders present SQL queries used for table creation and transformations. The data moves from the raw layer to the staging to the mart layer. In raw layer, data is loaded without any transformations. Only pri key and constraints are added. In the staging layer, the data from raw layers is transformed, like calculation cols are added, datatypes are changes, values are extracted. In the last layer, mart, ```fact tables``` for meta and shopify data are created by aggregating data on the date level and merging it. As the case study did not require dimensional data like campaigns, products, etc., the ```dim tables``` were not created in DWH. If I were to create dim tables, I would prefer ```star schema```, as it is ideal for ```read performance```
  
* ```visualization:``` The data from the mart layer is imported in Power BI for visualization. The fact table imported is joined to the ```dim date``` table on the date column in Power BI to visualize data on the date level. The KPIs like CAC, MER, aMER and %MoM, %DoD for them are also calculated in Power BI. In addition, ```random target``` values are added for CAC, MER, and aMER and displayed on the dashboard just for illustration. The KPIs are calculated based on the KLAR logic provided on the website. Adjusted MER is assumed as Acquisition MER

