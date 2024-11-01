import requests
import pandas as pd
import psycopg2
import csv


ad_account_id = '******' 
access_token = '*****' 

# URL to fetch data from Insights API. 'date_preset=maximun' returns data for entire history, '/campaigns?field=id,name fetches campaign id and name
url = f"https://graph.facebook.com/v21.0/{ad_account_id}/campaigns?field=id,name&date_preset=maximum"
params = {
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

print(df)
