import requests
import pandas as pd
import psycopg2
import csv


campaign_id = '*****' 
access_token = '*****' 

# Columns to fetch
fields = [
    'account_currency,account_name,ad_id,ad_name,adset_id,'
    'adset_name,campaign_id,campaign_name,clicks,'
    'date_start,date_stop,impressions,spend'
]

# URL to fetch data from Insights API. 'date_preset=maximun' returns data for entire history, 'time_increment=1' gives data on date level
url = f"https://graph.facebook.com/v21.0/{campaign_id}/insights?&date_preset=maximum&time_increment=1&limit=5000"
params = {
    'fields': ','.join(fields),
    'access_token': access_token,
}

# GET request to fetch data from API. Output is HTTP Response Content (JSON content) is stored in response variable
response = requests.get(url, params=params)

# Converts the JSON content into Python dictionary, making data easier to work in Python
data = response.json()

# Loads data in tabular form
df = pd.DataFrame(data['data'])

# Generates csv file
df.to_csv('data/raw_meta_afterwork_campaign.csv', index=False)

# To connect to PostgreSQL
def connect_to_postgres(dbname, user, password, host, port):
    try:
        conn = psycopg2.connect(
            dbname=dbname,
            user=user,
            password=password,
            host=host,
            port=port
        )
        print("Connection successful!")
        return conn
    except Exception as e:
        print(f"Error: {e}")
        return None


# To import CSV data into PostgreSQL
def import_csv_to_postgres(conn, schema_name, table_name, csv_file_path):
    try:
        # Opens a cursor to perform database operations
        cur = conn.cursor()

        # Opens the CSV file
        with open(csv_file_path, 'r') as f:
            reader = csv.reader(f)
            # Skips the header row 
            next(reader)

            # Function to insert each row into the table
            for row in reader:
                query = f"INSERT INTO {schema_name}.{table_name} VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"  #9 columns in csv file so 9 '%s'

        # Commit the transaction
        conn.commit()
        print("CSV data imported successfully!") # to know if successful after code execution

        # Closes the cursor and connection
        cur.close()
    except Exception as e:
        print(f"Error: {e}")


# Connection details
dbname = "ecom"
user = "postgres"
password = "*****"
host = "localhost"  
port = "5433" 

# CSV file taht will be loaded
csv_file_path = "raw_meta_afterwork_campaign.csv" 

# Schema & table name in PostgreSQL
schema_name = "raw"
table_name = "raw_meta_afterwork_campaign"

# Connects to PostgreSQL
conn = connect_to_postgres(dbname, user, password, host, port)

if conn:
    # Imports CSV into PostgreSQL
    import_csv_to_postgres(conn, schema_name, table_name, csv_file_path)

    # Closes the connection
    conn.close()
