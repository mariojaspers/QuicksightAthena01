# Part 1 - Exploring NYC Taxi public data set

## Prerequisites

1. Create an [AWS account](https://aws.amazon.com/free/)

## Setup IAM Permissions for Athena

1. Access the IAM console and select **Users**.  Then select your username
2. If you already have **AdministrorAccess** policy associated with your account you can skip the permission steps.
3. Click **Add Permissions** button
![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/select_user.png "Add Permissions")
1. Select **Attach Existing Policies Directly** box and hit **Create Policy**
![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/add_permission.png "Attach Existing Policies Directly")
1. From the list of managed policies, attach the following:
  - AmazonAthenaFullAccess
  - AWSQuicksightAthenaAccess
  - AmazonS3FullAccess
## Creating an Athena Table
We will be using the NYC Public Taxi dataset for this excercise available in **s3://serverless-analytics/canonical/NY-Pub/**

1. Open the Athena console
2. Before we can create our table, lets first create a database by entering `CREATE DATABASE taxis` into the **Query Editor** box and clicking **Run Query**
3. Next we create our table schema. In the Query Editor box, enter the following and click **Run Query**

```sql
CREATE EXTERNAL TABLE taxis (
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
```

1. Since this is a partitioned table, denoted by the PARTITIONED BY clause, we need to update the partitions.<br>

Enter `MSCK REPAIR TABLE taxis` and click Run Query
2. Verify that all partitions were added by entering `SHOW PARTITIONS taxis.trips` and click Run Query
![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/show_partitions.png "SHOW PARTITIONS trips")
1. Verify that we have data by clicking the icon to the right of our **Trips** table
![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/select_taxis.png "Select Trips Table")
1. Try selecting the top ten yellow taxis in 2016 ordered by pickup time in descending order

```sql
SELECT *
FROM taxis.taxis
WHERE year=2016 AND type='yellow'
ORDER BY pickup_datetime desc
LIMIT 10;
```
