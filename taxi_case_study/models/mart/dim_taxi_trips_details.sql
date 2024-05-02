WITH enriched_trips AS (
    SELECT
        trip_id,
        taxi_id,
        DATE(trip_start_timestamp) AS trip_date,
        trip_start_timestamp,
        trip_end_timestamp,
        trip_seconds,
        trip_miles,
        fare,
        tips,
        tolls,
        extras,
        trip_total,
        pickup_longitude,
        pickup_latitude,
        dropoff_longitude,
        dropoff_latitude
    FROM {{ ref('stg_taxi_trips') }}
)

SELECT
    *
FROM enriched_trips
