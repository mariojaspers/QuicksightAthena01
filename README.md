# Quicksight and Athena Workshop - AWS & Slalom
Amazon QuickSight and Amazon Athena workshop. Workshop will focus on ingesting data into Athena, combining it with other data sources, and visualizaing it in QuickSight.

Hands on workshop is broken up into 5 different sections to get you familar with the Quicksight and Athena products:</br>
- [5 min  - Sign Up for AWS ($100 Credit)](./Part1)</br>
- [10 min - Architecture and Permissions](./Part-2)</br>
- [20 min - Query a file on S3](./Part-3)</br>
- [20 min - Introducing Glue and Athena](./Part-4)</br>
- [50 min - Visualizing and Dashboarding with QuickSight](./Part-5)</br>

## Sign Up for AWS

### Create your AWS Account
Navigate to [Amazon AWS Free Tier](aws.amazon.com/free).
There are a variety of services that offer free tier to start building your solutions.

For showing up today at this workshop, AWS will provide a $100 credit voucher towards any services you use today.

### Apply Credit to your Account
The workshop facilitators will provide you with a credit voucher to apply to your account. This will give you plenty of credit to complete today's workshop and continue exploring AWS services.

To apply credit voucher:
  1.Click on your user name at the top right corner of the console
  1.Navigate to *my account* in the top right corner of the console
  1.Click on credit on the left hand side menu.
  1.Enter the promo code provided and follow the instructions.

## Architecture and Permissions
Purpose of serverless components is to reduce the overhead of maintaining, provisioning, and managing servers to serve applications. AWS provides three compelling serverless services through AWS to store large amounts of data, manipulate data at scale, query data at scale and speed, and easily visualize it.
<br/>
![alt text](https://www.lucidchart.com/publicSegments/view/e8256598-2b81-4121-a57f-69783a55f968/image.png)
<br/> To get these services working we need to allow these services to talk to one another. Following we will set up permissions for to accomplish this through AWS IAM.
<hr/>

## Setup IAM Permissions for Amazon Athena
Insert stuff for Athena

## Setup IAM Permissions for Amazon QuickSight
Insert stuff for Quicksight

## Setup IAM Permissions for AWS Glue

#### Alternatively, you can run the [CloudFormation Template](scripts/cf_createIAM_GlueServiceRole.json) in this folder cf_createIAMRole_GlueServiceRole.json

1. Access the IAM console and select **Users**.  Then select your username
2. Click **Add Permissions** button
3. From the list of managed policies, attach the following:
  - AWSGlueConsoleFullAccess
  - CloudWatchLogsReadOnlyAccess
  - AWSCloudFormationReadOnlyAccess

### Setup AWS Glue default service role

1. From the IAM console click **Roles** and create a new role
2. Name it **AWSGlueServiceRole**.  If you choose a different name you will need to manually create a new policy.
3. Select the **AWS Glue Service Role** from the **AWS Service Role** list
<br />![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/glue_role_type.png)<br/>
1. From the list of managed policies, attach the following:
  - AWSGlueServiceRole
  - AWSGlueServiceNotebookRole
  - AmazonS3FullAccess

### Create S3 Bucket for our data
1. Open the S3 Console from the Services drop down menu
<br />![alt text](https://github.com/mariojaspers/QuicksightAthena01/blob/Athena-mod/images/s301.PNG)<br/>
2. Click on **Create Bucket**
<br />![alt text](https://github.com/mariojaspers/QuicksightAthena01/blob/Athena-mod/images/s302.PNG)<br/>
2. Choose name for your bucket. Your bucket name needs to be globally unique and DNS compliant. 
<br />![alt text](https://github.com/mariojaspers/QuicksightAthena01/blob/Athena-mod/images/s303.PNG)<br/>
2. Your bucket is ready for use.

## Query a file on S3
1. Open the S3 Console from the Services drop down menu
2. Click your newly created bucket, by you or by our CloudFormation script.
1. Hit **Create folder** and name it "My-First-Athena-Table"
1. Download sample dataset [2010 Medicare Carrier Data](http://go.cms.gov/19xxPN4) and click on new folder and **Upload** the downloaded file. For your reference, here is the [data dictionary](https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/BSAPUFS/Downloads/2010_Carrier_Data_Dictionary.pdf) for this dataset.

1. Open the Athena console from the Services dropdown.
2. Select default database and run the following query
```sql
CREATE EXTERNAL TABLE default.medicare_payments_2010 (
    BENE_SEX_IDENT_CD integer,
    BENE_AGE_CAT_CD integer,
    CAR_LINE_ICD9_DGNS_CD string,
    CAR_LINE_HCPCS_CD string,
    CAR_LINE_BETOS_CD integer, 
    CAR_LINE_SRVC_CNT integer, 
    CAR_LINE_PRVDR_TYPE_CD integer,
    CAR_LINE_CMS_TYPE_SRVC_CD integer,
    CAR_LINE_PLACE_OF_SRVC_CD string, 
    CAR_HCPS_PMT_AMT decimal,
    CAR_LINE_CNT integer
    )
STORED AS TEXT
LINES DELIMITED BY '\n'
FIELDS DELIMITEED BY ','
LOCATION 's3://mybucketname/My-First-Athena-Table/'
```

2. From the **Database** pane on the left hand side, click **Create Table** drop down and select **Automatically**
<br />![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/create_table_crawler.png)<br/>
1. Enter a name for the crawler and select the IAM role we created in the previous section.  Click Next.
2. Select the **Specify path in another account** radio button and enter **s3://serverless-analytics/canonical/NY-Pub/** for the S3 path.  Click Next.
3. Do **not** add another data source and click Next.
4. For frequency leave as **Run on Demand** and click Next.
5. Click **Add Database** button and give your database a name, say **labs**
6. In order to avoid table name collision Glue generates a unique table name so we'll need to provide a prefix, say **taxis_** (include the underscore)
7. Click **Finish**
8. Check the box next to your newly created crawler and click **Run Crawler**.  It should take about a minute to run and create our table.

## Exploring Glue Data Catalog

1. On the left hand side, click **Databases**
2. Find the **labs** database and click on it
3. Click **Tables in labs** to view our newly created table
![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/show_taxi_table.png) <br />
1. Click the table name and explore

## Querying Taxi Data

1. Switch back to the Athena console
  - You may need to replace the database and/or table names with ones shown in the Data Catalog.
2. Enter `SHOW PARTITIONS labs.taxi_ny_pub` to verify all partitions were automatically added
3. Try the SQL statement below to explore the data.

```sql
SELECT *
FROM labs.taxi_ny_pub
WHERE year BETWEEN '2013' AND '2016' AND type='yellow'
ORDER BY pickup_datetime desc
LIMIT 10;
```
<br />![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/taxis_2013_2016.png) <br />

# Part 3 - Crawling, Transforming and Querying

## References

1. [Apache Spark](https://spark.apache.org/)
2. [PySpark API Reference](http://spark.apache.org/docs/2.1.0/api/python/pyspark.sql.html)

## The Data Source

We will use a public data set provided by [Instacart in May 2017](https://tech.instacart.com/3-million-instacart-orders-open-sourced-d40d29ead6f2) to look at Instcart's customers' shopping pattern.  You can find the data dictionary for the data set [here](https://gist.github.com/jeremystan/c3b39d947d9b88b3ccff3147dbcf6c6b)

## Crawling

1. Open the AWS Glue console
2. Select **Crawler** and click **Add Crawler**
3. Give your crawler a name and choose the Glue IAM role we created in Part 2.  **AWSGlueServiceRole**
4. Select **S3** as the **Data Source** and specify a path in **another account**.  Paste **s3://royon-customer-public/instacart/** as the S3 path.
5. Do not add any additional data sources and select **Run On Demand** for frequency
6. Create a new database called **instacart** and enter **raw_** as the table prefix
7. Click **Finish** to complete creating the crawler
8. Run the new crawler

## Transforming the Data

Before we get started with creating a Glue ETL job, we need to make one small change to the created tables.
Select Tables in the Data Catalog and search for **table_products**. Click **table_products** to open up the table details.
As you can see the Classification is _UNKNOWN_.  We need to fix it before continuing.

1. Click **Edit Table**
2. Scroll down to **Classification** and change the value to **csv**
3. Click **Apply** to save the changes
You may have also noticed that we don't have any column, that's ok, we'll fix this soon.

We'll now create an ETL job that will process all 5 tables that the crawler created, combine them into a single table and save in a Parquet optimized file format.

From the Glue ETL menu select **Jobs** and click **Add Job**

1. Give your job a name, **instacart_etl** and select our service role.  Leave all of the other options unchanged but select a **Temporary Directory**
2. From the **Data Sources** list select one of the Instcart tables, lets say **raw_orders**.  We can only select one table.
<br/>![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/etl_select_source.png "Select raw_orders")
1. When choosing our data targets select **Create tables in your data target**. Select **Amazon S3** for data store and **Parquet** for format.  Enter your own S3 bucket for target
<br/>![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/etl_data_target.png "Enter your own S3 Bucket")
1. In this step we can change the source to target column mapping but we will not change this now.  Click **Next**
2. Click **Finish** to complete creating our ETL

As you can see, AWS Glue created a script for you to get started.  If we didn't need to do anything else, this script simply converts our CSV data to Parquet.
If you remember we still need to fix the Products table.  Select everything in the script window and replace it with the code below.

Make you update the variables mentioned below

```python
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.job import Job

## Update these variables with your own information
DB_NAME = "instacart"

TBL_RAW_PRODUCTS = "raw_products"
TBL_RAW_ORDERS = "raw_orders"
TBL_RAW_ORDERS_PRIOR = "raw_orders_prior"
TBL_RAW_DEPT = "raw_departments"

OUTPUT_S3_PATH = "s3://royon-demo/instacart/"
##################

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

## Create Glue and Spark context variables
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

## Define the source tables from where to read data
products = glueContext.create_dynamic_frame.from_catalog(database = DB_NAME, table_name = TBL_RAW_PRODUCTS, transformation_ctx = "products").toDF()
orders = glueContext.create_dynamic_frame.from_catalog(database = DB_NAME, table_name = TBL_RAW_ORDERS, transformation_ctx = "orders").toDF()
orders_prior = glueContext.create_dynamic_frame.from_catalog(database = DB_NAME, table_name = TBL_RAW_ORDERS_PRIOR, transformation_ctx = "orders_prior").toDF()
departments = glueContext.create_dynamic_frame.from_catalog(database = DB_NAME, table_name = TBL_RAW_DEPT, transformation_ctx = "departments").toDF()

## Fix the products table which was missing columns and types
p_df = products.withColumn('product_id', products.col0.cast('bigint')) \
.withColumn('product_name', products.col1.cast('string')) \
.withColumn('aisle_id', products.col2.cast('bigint')) \
.withColumn('department_id', products.col2.cast('bigint')) \
.na.drop('any')
df = p_df.select('product_id', 'product_name', 'aisle_id', 'department_id')

## Drop records that contain any null values
orders = orders.na.drop('any')
orders_prior = orders_prior.na.drop('any')
departments = departments.na.drop('any')

## Join the prior orders table with the products table
priors_products = orders_prior.join(df, ['product_id'])

## Join the previously join table with the departments table
orders_prod_dept = priors_products.join(departments, ['department_id'])

## Write out the current orders table to S3 partitioned by order day of week
orders.orderBy('user_id').coalesce(10).write.partitionBy('order_dow').mode('overwrite').parquet(OUTPUT_S3_PATH + 'current_orders/')

## Write out the joined table partitioned by department name
orders_prod_dept.orderBy('order_id').coalesce(10).write.partitionBy('department').mode('overwrite').parquet(OUTPUT_S3_PATH + 'prior_orders/')

job.commit()
```

Now save and run your ETL job.  One thing to note is that we're writing out a new set of data to our own S3 bucket.
We need to configure a crawler to scan this new bucket and create appropriate tables in the Data Catalog so we can query them with Athena.

There is a little bit of cleanup we need to do in order to help the crawler produce better results.  When Apache Spark, what is used by the Glue ETL, does its work
it generates some temporary files. We will need to delete them.  In the output S3 bucket delete files named **name_$folder$**, **_metadata** and **_common_metadata**

From the Glue console select **Crawlers** and create a new crawler.  Point it to the top S3 bucket where you saved your results defined by **OUTPUT_S3_PATH** in the script above.  In my case that will be **s3://royon-demo/instacart/**.  Make sure you configure the table prefix to something other than raw_ so you can differentiate them from the previous ones we created, I used **table_**.  When the ETL job completes we can run our new crawler.  After the crawler completes you should see your new tables.
<br/>![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/instacart_parquet_tables.png "Parquet Tables")
<br/>Go ahead and explore the data.  Here is an example SQL query that counts orders and groups them by department.

```sql
SELECT count(*) AS count, department
FROM instacart."table_prior_orders"
GROUP BY department
```

Here is another example that counts the number of users that have placed orders during their lunch hour from 11am to 1pm grouped by the days of the week the order was placed.

```sql
SELECT count(user_id) as user_count, order_dow
FROM instacart."table_current_orders"
WHERE eval_set='prior' AND order_hour_of_day BETWEEN 11 and 13
GROUP BY order_dow
ORDER BY user_count desc
```
