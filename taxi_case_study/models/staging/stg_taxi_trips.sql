{{ config(materialized='table') }}

WITH taxi_trips AS (
    SELECT
        `Trips ID` AS trip_id,
        `Taxi ID` AS taxi_id,
        SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p',`Trip Start Timestamp`) AS trip_start_timestamp,
        SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p',`Trip End Timestamp`) AS trip_end_timestamp,
        SAFE_CAST(`Trip Seconds` AS FLOAT64) AS trip_seconds,
        SAFE_CAST(`Trip Miles` AS FLOAT64) AS trip_miles,
        `Pickup Census Tract` AS pickup_census_tract,
        `Dropoff Census Tract` AS dropoff_census_tract,
        `Pickup Community Area` AS pickup_community_area,
        `Dropoff Community Area` AS dropoff_community_area,
        SAFE_CAST(`Fare` AS FLOAT64) AS fare,
        SAFE_CAST(`Tips` AS FLOAT64) AS tips,
        SAFE_CAST(`Tolls` AS FLOAT64) AS tolls,
        SAFE_CAST(`Extras` AS FLOAT64) AS extras,
        SAFE_CAST(`Trip Total` AS FLOAT64) AS trip_total,
        `Payment Type` AS payment_type,
        `Company` AS company,
        SAFE_CAST(`Pickup Centroid Longitude` AS FLOAT64) AS pickup_longitude,
        SAFE_CAST(`Pickup Centroid Latitude` AS FLOAT64) AS pickup_latitude,
        SAFE.ST_GeogFromText(`Pickup Centroid Location`) AS pickup_location,
        SAFE_CAST(`Dropoff Centroid Longitude` AS NUMERIC) AS dropoff_longitude,
        SAFE_CAST(`Dropoff Centroid Latitude` AS NUMERIC) AS dropoff_latitude,
        SAFE.ST_GeogFromText(`Dropoff Centroid Location`) AS dropoff_location
    FROM {{ source('data_cityofchicago', 'taxi_trips_2023') }}
)

SELECT
    *
FROM taxi_trips
