SELECT 
    taxi_id,
    company,
    DATE(trip_start_timestamp) AS trip_date,
    payment_type,
    SUM(fare) AS total_fare,
    SUM(tips) AS total_tips,
    SUM(tolls) AS total_tolls,
    SUM(trip_total) AS total_charge,
    AVG(fare) AS average_fare,
    AVG(tips) AS average_tips
FROM {{ ref('stg_taxi_trips') }}
GROUP BY ALL
