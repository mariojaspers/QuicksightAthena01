# Quicksight and Athena Workshop - AWS & Slalom
Amazon QuickSight and Amazon Athena workshop. Workshop will focus on ingesting data into Athena, combining it with other data sources, and visualizaing it in QuickSight.

Hands on workshop is broken up into 5 different sections to get you familar with the Quicksight and Athena products:</br>
- [5 min  - Sign Up for AWS ($100 Credit)](./Part1)</br>
- [10 min - Architecture and Permissions](./Part-2)</br>
- [20 min - Query a file on S3](./Part-3)</br>
- [20 min - Introducing Glue and Athena](./Part-4)</br>
- [50 min - Visualizing and Dashboarding with QuickSight](./Part-5)</br>

# Sign Up for AWS

### Create your AWS Account
Navigate to [Amazon AWS Free Tier](aws.amazon.com/free).
There are a variety of services that offer free tier to start building your solutions.

For showing up today at this workshop, AWS will provide a $100 credit voucher towards any services you use today.

### Apply Credit to your Account
The workshop facilitators will provide you with a credit voucher to apply to your account. This will give you plenty of credit to complete today's workshop and continue exploring AWS services.

To apply credit voucher:
1.Click on your user name at the top right corner of the console
1.Navigate to *my account* in the top right corner of the console
<br />![alt text]("https://github.com/mariojaspers/QuicksightAthena01/blob/Athena-mod/images/My+Account.PNG")<br/>
1.Click on credit on the left hand side menu.
<br />![alt text](https://github.com/mariojaspers/QuicksightAthena01/blob/Athena-mod/images/Credit.PNG)<br/>
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

# Query a file on S3
1. Open the S3 Console from the Services drop down menu
2. Click your newly created bucket, by you or by our CloudFormation script.
1. Hit **Create folder** and name it "My-First-Athena-Table"
1. Download sample dataset [2010 Medicare Carrier Data](http://go.cms.gov/19xxPN4) and click on new folder and **Upload** the downloaded file. For your reference, here is the [data dictionary](https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/BSAPUFS/Downloads/2010_Carrier_Data_Dictionary.pdf) for this dataset.

1. Open the Athena console from the Services dropdown.
2. Create a table manually in the default database named **medicare_payments_2010**:

|Field Name|Data Type|
|----------|:--------|
|BENE_SEX_IDENT_CD|int|
|BENE_AGE_CAT_CD|int|
|CAR_LINE_HCPCS_CD|string|
|CAR_LINE_ICD9_DGNS_CD|string|
|CAR_LINE_BETOS_CD|string|
|CAR_LINE_SRVC_CNT|string|
|CAR_LINE_PRVDR_TYPE_CD|string|
|CAR_LINE_CMS_TYPE_SRVC_CD|string|
|CAR_LINE_PLACE_OF_SRVC_CD|string|
|CAR_HCPS_PMT_AMT|string|
|CAR_LINE_CNT|string|

3. Run the following SQL statement and make sure that your table is reading correctly:
```sql
SELECT * 
FROM default.medicare_payments_2010 LIMIT 100
```
4. Show Create Table statement helps you better understand what it going on behind the scenes when creating a table.
```sql
SHOW CREATE TABLE default.medicare_payments_2010
```

More resources:
- [Athena Supported Formats](http://docs.aws.amazon.com/athena/latest/ug/supported-formats.html)
- [Athena Language Reference](http://docs.aws.amazon.com/athena/latest/ug/language-reference.html)

Congratulations, you queried your first S3 file through Amazon Athena!

# Introducing Glue and Athena
One of the many benefits of Glue, is its ability to discover and profile data from S3 Objects. This become handy in quickly creating a catalog of new and incoming data.
To get started:
1. In Athena, from the **Database** pane on the left hand side, click **Create Table** drop down and select **Automatically**
<br />![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/create_table_crawler.png)<br/>
1. Enter a name for the crawler and select the IAM role we created in the previous section.  Click Next.
2. Select the **Specify path in another account** radio button and enter **s3://serverless-analytics/canonical/NY-Pub/** for the S3 path.  Click Next.
3. Do **not** add another data source and click Next.
4. For frequency leave as **Run on Demand** and click Next.
5. Click **Add Database** button and give your database a name, say **labs**
6. In order to avoid table name collision Glue generates a unique table name so we'll need to provide a prefix, say **taxis_** (include the underscore)
7. Click **Next**
8. Review the information is correct, specifically the "Include Path" field. Hit **Finish** when complete.
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
<br/>![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/taxis_2013_2016.png) <br/>

## Crawling Breakout - Discover Instacart Data
In this section, we will break out and follow the same instructions, but while loading data from another public source, Instacart. Instacart company that operates as a same-day grocery delivery service. Customers select groceries through a web application from various retailers and delivered by a personal shopper. 
Instacart has published a public datasource to provide insight into consumer shopping trends for over 200,000 users. Data [Instacart in May 2017](https://tech.instacart.com/3-million-instacart-orders-open-sourced-d40d29ead6f2) to look at Instcart's customers' shopping pattern.  You can find the data dictionary for the data set [here](https://gist.github.com/jeremystan/c3b39d947d9b88b3ccff3147dbcf6c6b)

Source s3 bucket: **s3://royon-customer-public/instacart/**

### Expected output
![alt text](http://amazonathenahandson.s3-website-us-east-1.amazonaws.com/images/etl_select_source.png "Select raw_orders")

#Visualizing and Dashboarding with Quicksight

## Getting the data

blablebla

## SPICE 

blablabal 

### the end

