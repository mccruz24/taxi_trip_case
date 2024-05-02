### DBT Project for Chicago Taxi Trips Analysis

Overview
This DBT project is developed to analyze taxi trip data from the city of Chicago for the year 2023. The data is sourced from the City of Chicago's public data portal, downloaded, and stored in Google Cloud Storage. It is then ingested into Google BigQuery as a CSV file. This project utilizes the BigQuery DBT plugin and is configured to use a Google Cloud Platform (GCP) service account for authentication.

The primary objective of this project is to transform raw taxi trip data into a more structured and query-optimized format using staging and dimension tables. This structured data will then be used to answer key business questions regarding taxi trips within the city.

Note: Initially I wanted to use duckdb as database in this project. However, I have faced difficulties in utilizing duckdb when developing the project. I opted to use BigQuery instead.


## Data Pipeline
Data Extraction: Extract the 2023 taxi trip data from the City of Chicago's data portal.

Data Storage: Upload the extracted CSV file to Google Cloud Storage.

Data Loading: Load the data into a BigQuery table from the CSV file stored in Google Cloud Storage.

DBT Initialization: Set up a DBT project with the BigQuery plugin. Configure the project to use a service account created in GCP for secure authentication.

Data Transformation:
Create a staging table (stg_taxi_trips) to convert raw data column types into appropriate data types.
Develop dimension tables such as dim_taxi_trips_details, dim_taxi_drivers, dim_time, and dim_locations to support analytical queries.

## Analysis Objectives

The project aims to answer the following analytical questions:
```

Volume Analysis: How many taxi trips were completed in Chicago during 2023?

Performance Analysis: Which taxi company performs better in terms of service metrics such as fare, tips, and customer satisfaction?

Time Analysis: What are the peak hours for taxi drivers in Chicago?

Economic Analysis: Is there a correlation between the fare, total trip cost, and the tips received?
                 : Does the distance traveled influence the tips given by customers?

Payment Preferences: How do customers of taxi companies choose to pay?

Demographic Impact: Does high population density affect the total number of taxi trips in the city?
```
```
dbt_project/
│
├── models/
│   │   
│   ├── staging/
│   │   └── stg_taxi_trips.sql          # Staging model for raw taxi trips data
│   ├── mart/     
│       ├── dim_taxi_trips_details.sql  # Dimension model for detailed trip information
│       └── dim_taxi_charges.sql        # Dimension model for charges per trip 
│ 
├── ingestion/
│   └── get_raw_data.py                 # Python script that extracts the data
│                                       # from Chicago's data portal to load in duckdb 
│                                       # but opted to change to BigQuery
│
├── target/                             # DBT generated files post-run (e.g., logs, manifest)
├── dbt_profiles.yml                    # Configuration file for DBT profiles
└── README.md
```

## Configuration
To run this DBT project, ensure the following:

- A GCP service account is set up with appropriate permissions to access BigQuery and Google Cloud Storage.
- The dbt_profiles.yml file is correctly configured to use this service account for DBT runs.

## Running the Project
To execute the transformations and generate the analytical views, use the following DBT commands:

dbt run    # Executes all models
dbt test   # Runs tests to validate the integrity of the data

## Conclusion
This DBT project facilitates a comprehensive analysis of the taxi industry in Chicago by structuring raw trip data into insightful dimensions and measures. By answering key business questions, the project helps stakeholders make informed decisions to improve taxi services and customer satisfaction.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
