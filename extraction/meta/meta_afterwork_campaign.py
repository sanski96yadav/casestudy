import requests
import pandas as pd
import psycopg2
import csv

# Define your ad account ID and access token
campaign_id = '120209189288510302'  # Replace with your actual ad account ID
access_token = 'EAAlDMc8HPp0BO2GxOkMxKUWAhNdzrTsLTW17Wl574PDPDZBFea1KKbA07KLln9ZBVIbOwM2xjA2nSlH9DY9Ctb9zgqjudZBajvYUdDEXT5gThvV8nnJEI4xwF9tIaHRSwsBGlj1w8oHKRtae4VWhZAP8xQactZCcuJB8ZAJUWRo8M1oQUJYfMwkDRA'  # Replace with your actual access token

# Define the fields you want to fetch
fields = [
    'account_currency,account_name,ad_id,ad_name,adset_id,'
    'adset_name,campaign_id,campaign_name,clicks,'
    'date_start,date_stop,impressions,spend'
]

# Construct the URL
url = f"https://graph.facebook.com/v21.0/{campaign_id}/insights?&date_preset=maximum&time_increment=1&limit=5000"
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

df.to_csv('raw_meta_afterwork_campaign.csv', index=False)

# Function to connect to PostgreSQL
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


# Function to import CSV data into PostgreSQL
def import_csv_to_postgres(conn, schema_name, table_name, csv_file_path):
    try:
        # Open a cursor to perform database operations
        cur = conn.cursor()

        # Open the CSV file
        with open(csv_file_path, 'r') as f:
            reader = csv.reader(f)
            # Skip the header row (if your CSV file has a header)
            next(reader)

            # Loop through the CSV and insert each row into the table
            for row in reader:
                # Customize this query based on your table structure and CSV format
                query = f"INSERT INTO {schema_name}.{table_name} VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"  # Update %s based on the number of columns
                cur.execute(query, row)

        # Commit the transaction
        conn.commit()
        print("CSV data imported successfully!")

        # Close the cursor and connection
        cur.close()
    except Exception as e:
        print(f"Error: {e}")


# Connection details
dbname = "klar"
user = "postgres"
password = "81375"
host = "localhost"  # Or your host address
port = "5433"  # Default PostgreSQL port

# File path to your CSV file
csv_file_path = "raw_meta_afterwork_campaign.csv"

# Table name in PostgreSQL
schema_name = "raw"
table_name = "raw_meta_afterwork_campaign"

# Connect to PostgreSQL
conn = connect_to_postgres(dbname, user, password, host, port)

if conn:
    # Import CSV into PostgreSQL
    import_csv_to_postgres(conn, schema_name, table_name, csv_file_path)

    # Close the connection
    conn.close()
