#OUTPUT OF THE CODE WAS USED TO CROSS CHECK DATA RETRIEVED ON DATE & CAMPAIGN LEVEL

import requests
import pandas as pd
import psycopg2
import csv

# Define your ad account ID and access token
ad_account_id = '******'  # Replace with your actual ad account ID
access_token = '*****'  # Replace with your actual access token

# Define the fields you want to fetch
fields = [
    'account_currency,account_name,impressions,spend'
]

# Construct the URL
url = f"https://graph.facebook.com/v21.0/{ad_account_id}/insights?&date_preset=maximum"
params = {
    'fields': ','.join(fields),
    'access_token': access_token,
}

# Make the GET request to fetch data
response = requests.get(url, params=params)
# to see all columns with values
pd.set_option('display.max_columns', None)

# Convert the response to JSON
data = response.json()

# Load data into a pandas DataFrame
df = pd.DataFrame(data['data'])

# Display the data in a tabular format

df.to_csv('meta_data_summary.csv', index=False)
