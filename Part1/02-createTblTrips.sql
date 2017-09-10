CREATE EXTERNAL TABLE taxis.trips (
     vendorid STRING,
     pickup_datetime TIMESTAMP,
     dropoff_datetime TIMESTAMP,
     ratecode INT,
     passenger_count INT,
     trip_distance DOUBLE,
     fare_amount DOUBLE,
     total_amount DOUBLE,
     payment_type INT
    )
PARTITIONED BY (YEAR INT, MONTH INT, TYPE string)
STORED AS PARQUET
LOCATION 's3://serverless-analytics/canonical/NY-Pub/'
