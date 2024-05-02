import requests
import pandas as pd
import time
import duckdb

def fetch_all_taxi_trips(max_records=1000000):
    url = "https://data.cityofchicago.org/resource/wrvz-psew.json"
    limit = 50000  # Number of records per request
    offset = 0
    total_records = []
    retries = 3  # Number of retries on failure
    fetched_records = 0  # Counter for records fetched so far

    while fetched_records < max_records:
        current_fetch_limit = min(limit, max_records - fetched_records)  # Adjust limit to not exceed max_records
        params = {
            '$limit': current_fetch_limit,
            '$offset': offset,
            '$$app_token': '5jNhUg7vBcdYjRiuT3Gnqa8yt'
        }

        response = requests.get(url, params=params)
        if response.status_code == 500 and retries > 0:
            print(f"Server error, retrying... ({retries} retries left)")
            retries -= 1
            time.sleep(5)  # Wait 5 seconds before retrying
            continue
        elif response.status_code != 200:
            raise Exception(f"Failed to fetch data: HTTP {response.status_code} - {response.text}")

        batch = response.json()
        batch_length = len(batch)
        if batch_length == 0:
            break

        total_records.extend(batch)
        fetched_records += batch_length
        offset += batch_length
        print(f"Total records fetched: {fetched_records}")
        retries = 3  # Reset retries for the next batch

    return pd.DataFrame(total_records)

def store_data_in_duckdb(dataframe):
    conn = duckdb.connect('dev.duckdb')
    try:
        # Define schema based on the structure of your data
        conn.execute("""
            CREATE TABLE IF NOT EXISTS taxi_trips_raw (
                trip_id VARCHAR,
                trip_start_timestamp TIMESTAMP,
                trip_end_timestamp TIMESTAMP,
                trip_miles FLOAT,
                fare FLOAT,
                tips FLOAT,
                tolls FLOAT,
                extras FLOAT,
                total FLOAT,
                payment_type VARCHAR,
                company VARCHAR,
                pickup_latitude FLOAT,
                pickup_longitude FLOAT,
                dropoff_latitude FLOAT,
                dropoff_longitude FLOAT
            )
        """)
        conn.execute("INSERT INTO taxi_trips_raw SELECT * FROM dataframe;")
        print("Data successfully stored in DuckDB.")
    except Exception as e:
        print(f"An error occurred while storing data: {e}")
    finally:
        conn.close()

# Example usage of the function
if __name__ == '__main__':
    df = fetch_all_taxi_trips()
    if not df.empty:
        store_data_in_duckdb(df)
    else:
        print("No data fetched to store.")

