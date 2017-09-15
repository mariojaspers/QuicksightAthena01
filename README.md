# Quicksight and Athena Workshop - AWS & Slalom
Amazon QuickSight and Amazon Athena workshop. Workshop will focus on ingesting data into Athena, combining it with other data sources, and visualizaing it in QuickSight.

Hands on workshop is broken up into 5 different sections to get you familar with the Quicksight and Athena products:</br>
- [5 min  - Sign Up for AWS ($100 Credit)](#sign-up-for-aws)</br>
- [10 min - Architecture and Permissions](#architecture-and-permissions)</br>
- [20 min - Query a file on S3](#query-a-file-on-s3)</br>
- [20 min - Introducing Glue and Athena](#introduction-glue-and-athena)</br>
- [50 min - Visualizing and Dashboarding with QuickSight](#visualizing-and-dashboarding-with-quicksight)</br>

# Sign Up for AWS

### Create your AWS Account
Navigate to [Amazon AWS Free Tier](aws.amazon.com/free).
There are a variety of services that offer free tier to start building your solutions.

For showing up today at this workshop, AWS will provide a $100 credit voucher towards any services you use today.

### Apply Credit to your Account
The workshop facilitators will provide you with a credit voucher to apply to your account. This will give you plenty of credit to complete today's workshop and continue exploring AWS services.

To apply credit voucher:</br>
1. Click on your user name at the top right corner of the console
1. Navigate to *my account* in the top right corner of the console
<br />![alt text](/images/myAccount.PNG)<br/><br/>
1. Click on credit on the left hand side menu.
<br />![alt text](/images/Credit.PNG)<br/><br/>
1. Enter the promo code provided and follow the instructions.

# Architecture and Permissions
Purpose of serverless components is to reduce the overhead of maintaining, provisioning, and managing servers to serve applications. AWS provides three compelling serverless services through AWS to store large amounts of data, manipulate data at scale, query data at scale and speed, and easily visualize it - namely **AWS Glue, Amazon Athena, Amazon QuickSight.**
<br/>
![alt text](https://www.lucidchart.com/publicSegments/view/a17a8684-4bc6-4d14-b885-4f4dc5878e7e/image.png)
<br/> To get these services working we need to allow these services to talk to one another. Following we will set up permissions for to accomplish this through AWS IAM.
<hr/>

## Setup IAM Permissions for AWS Glue

#### Alternatively, you can run the [CloudFormation Template](/scripts/cf_createIAM_GlueServiceRole.json).

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

## Create S3 Bucket for our data
1. Open the S3 Console from the Services drop down menu
<br />![alt text](/images/s301.PNG)<br/>
2. Click on **Create Bucket**
<br />![alt text](/images/s302.PNG)<br/>
2. Choose name for your bucket. Your bucket name needs to be globally unique and DNS compliant. 
<br />![alt text](/images/s303.PNG)<br/>
2. Your bucket is ready for use.
</hr>
</br>
# Query a file on S3
To get started with Athena and QuickSight, we need to provide data to query. This data may orginate from a varierty of sources into S3, but for this example we will upload a file into S3 manually.
1. Open the S3 Console from the Services drop down menu
2. Click your newly created bucket, by you or by our CloudFormation script.
1. Hit **Create folder** and name it "B2B"
1. Create another folder within B2B called "orders"
1. Download sample dataset [B2B Orders](https://slalom-seattle-ima.s3-us-west-2.amazonaws.com/docs/B2B%20Dataset.zip). Unzip the dataset files into a folder. Click on new folder and **Upload** the **orders.csv**.

1. Open the **Athena** console from the Services dropdown.
2. Create a table manually called **orders** in the a database named **labs**:
### Orders
|Field Name|Data Type|
|----------|:--------|
|ROW_ID|int|
|ORDER_ID|string|
|ORDER_DATE|date|
|SHIP_DATE|date|
|SHIP_MODE_ID|int|
|CUSTOMER_ID|string|
|SEGMENT|int|
|PRODUCT_ID|string|
|SALES|double|
|COMPANY_ID|int|
|QUANTITY|int|
|DISCOUNT_PCT|double|
|PROFIT_AMT|double|


3. Run the following SQL statement and make sure that your table is reading correctly:
```sql
SELECT * 
FROM labs.orders LIMIT 100
```
4. Show Create Table statement helps you better understand what it going on behind the scenes when creating a table.
```sql
SHOW CREATE TABLE default.orders
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

```sql
SELECT 
  year,
  type, 
  count(*), 
  avg(fare_amount) avg_fare, 
  lag(fare_amount) over(partition by type order by year desc) last_year_avg_fare
FROM labs.taxi_ny_pub
GROUP BY year, type
```

You have the ability to **Save a query** for future re-use.

## Breakout - Load B2B Dataset

Now that we have learned about crawlers, lets put it to use to load the rest of our [B2B Orders](https://slalom-seattle-ima.s3-us-west-2.amazonaws.com/docs/B2B%20Dataset.zip) dataset.

- Unzip the data, and upload it to your S3 Bucket **remember, one folder represents one table.**
- Run a crawler through your bucket to discovery the dataset.
- Add new tables to the **labs** database with prefix **b2b_**

Make sure to check fields, and how Glue is parsing your data. Correct any mistakes. Once complete, you should be able to run this query: 
```sql
SELECT
  year(date_parse(Order_Date,'%c/%e/%Y')) Order_Year,
  Company_Name,
  SUM(quantity) Quantity,
  SUM(sales) Total_Sales,
  SUM(sales)/revenue_billion Sales_to_Revenue_Ratio
FROM labs.b2b_orders o
  JOIN labs.b2b_company co on  co.company_id = o.company_id
  JOIN labs.b2b_customer cu on cu.customer_id = o.customer_id
  JOIN labs.b2b_product p on p.product_id = o.product_id
  JOIN labs.b2b_segment s on s.segment_id = o.segment_id
  JOIN labs.b2b_ship_mode sm on sm.ship_mode_id = o.ship_mode_id
  JOIN labs.b2b_company_financials cp on cp.company_id = co.company_id
  JOIN labs.b2b_industry i on i.industry_id = co.industry_id
GROUP BY
  year(date_parse(Order_Date,'%c/%e/%Y')),
  Company_Name,
  revenue_billion
ORDER BY
  SUM(sales)/revenue_billion DESC
LIMIT 100
```
<br/>![alt text](/images/TopCustomersResults.PNG)<br/>

## Crawling Breakout - Discover Instacart Data
In this section, we will break out and follow the same instructions, but while loading data from another public source, Instacart. Instacart company that operates as a same-day grocery delivery service. Customers select groceries through a web application from various retailers and delivered by a personal shopper. 
Instacart has published a public datasource to provide insight into consumer shopping trends for over 200,000 users. Data [Instacart in May 2017](https://tech.instacart.com/3-million-instacart-orders-open-sourced-d40d29ead6f2) to look at Instcart's customers' shopping pattern.  You can find the data dictionary for the data set [here](https://gist.github.com/jeremystan/c3b39d947d9b88b3ccff3147dbcf6c6b)

Source s3 bucket: **s3://royon-customer-public/instacart/**

### Expected output
![alt text](/images/instacartResults.PNG "Expected Results")


## Notes on best practices
- Partition your data
- Compress your data!
- With large datasets, split your files into ~100MB files
- Convert data to a columnar format, with large datasets. 

For more great tips view [this post](https://aws.amazon.com/blogs/big-data/top-10-performance-tuning-tips-for-amazon-athena/) on AWS Big Data blog.

# Visualizing and Dashboarding with QuickSight

## Getting the data

blablebla

## SPICE 

blablabal 

### the end

