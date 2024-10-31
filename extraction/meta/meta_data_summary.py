#OUTPUT OF THE CODE WAS USED TO CROSS CHECK DATA RETRIEVED ON DATE & CAMPAIGN LEVEL

import requests
import pandas as pd
import psycopg2
import csv


ad_account_id = '******' 
access_token = '*****' 

# Define the fields you want to fetch
fields = [
    'account_currency,account_name,impressions,spend'
]

# URL to fetch data from API
url = f"https://graph.facebook.com/v21.0/{ad_account_id}/insights?&date_preset=maximum"
params = {
    'fields': ','.join(fields),
    'access_token': access_token,
}

# GET request to fetch data from API
response = requests.get(url, params=params)
# to see all columns with values
pd.set_option('display.max_columns', None)

# Converts the response to JSON
data = response.json()

# Loads data into a pandas DataFrame
df = pd.DataFrame(data['data'])

# Gives csv file
df.to_csv('meta_data_summary.csv', index=False)
