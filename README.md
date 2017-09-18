# Quicksight and Athena Workshop - AWS & Slalom
Amazon QuickSight and Amazon Athena workshop. Workshop will focus on ingesting data into Athena, combining it with other data sources, and visualizaing it in QuickSight.

Hands on workshop is broken up into 5 different sections to get you familar with the Quicksight and Athena products:</br>
- [5 min  - Sign Up for AWS ($100 Credit)](#sign-up-for-aws)</br>
- [10 min - Architecture and Permissions](#architecture-and-permissions)</br>
- [10 min - Query a file on S3](#query-a-file-on-s3)</br>
- [10 min - Introducing Glue & Athena](#introduction-glue-and-athena)</br>
- [20 min - Breakout Exercises](#breakout-exercises)</br>
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
1. Navigate to **My Account** in the top right corner of the console
<br />![alt text](/images/myAccount.PNG)<br/><br/>
1. Click on **Credits** on the left hand side menu.
<br />![alt text](/images/Credit.PNG)<br/><br/>
1. Enter the promo code provided and follow the instructions.
<hr/></br>

# Architecture and Permissions
Purpose of serverless components is to reduce the overhead of maintaining, provisioning, and managing servers to serve applications. AWS provides three compelling serverless services through AWS to store large amounts of data, manipulate data at scale, query data at scale and speed, and easily visualize it - namely **AWS Glue, Amazon Athena, Amazon QuickSight.**
<br/>
![alt text](/images/architecture.png)
<br/> To get these services working we need to allow these services to talk to one another. Following we will set up permissions for to accomplish this through AWS IAM.


## Build Permissions and S3 Bucket
AWS provides a service to build resources out of predefined templates using CloudFormation. We will use a CloudFormation script to automate the creation of permissions, roles, and other elements we may require.

To create this we need to run a cloud formation template:
1. Under services, click **CloudFormation** under Mangement Tools. </br>
![alt text](/images/cloudFormation.PNG)</br></br>
2. Click **Create Stack**
3. Under "Choose a template", select the **"Specify an Amazon S3 template URL"** radio button option and enter this template url: 
```
https://s3-us-west-2.amazonaws.com/slalom-seattle-ima/scripts/cloudformation/cf_QuickSightAthena_Workshop.template
```
4. Click **Next**
5. Enter the a name for your stack, like **QuicksightAthena-Workshop**
5. Provide a unique name for your bucket to store your data - **It needs to be globally unique name and the bucket name must contain only lowercase letters, numbers, periods (.), and dashes (-). No spaces!**
5. Hit **Next**
5. Hit **Next**
5. There is an acknowledge checkbox for you to review, and hit **Create**
6. We will wait a couple minutes until the progess says CREATE_COMPLETE</br>
![alt text](/images/cloudformationStatus.PNG)
<hr/></br>

# Query a file on S3
To get started with Athena and QuickSight, we need to provide data to query. This data may orginate from a varierty of sources into S3, but for this example we will upload a file into S3 manually.
1. **Open the S3 Console** from the Services drop down menu
2. Click your newly created bucket, by you or by our CloudFormation script.
1. Hit **Create folder** and name it "B2B"
1. Create another folder within B2B called "orders"
1. Download sample dataset [B2B Orders](https://slalom-seattle-ima.s3-us-west-2.amazonaws.com/docs/B2B%20Dataset.zip). Unzip the dataset files into a folder. Click on new folder and **Upload** the **orders.csv**.
2. Make note of the folders you saved this file under.

1. Open the **Athena** console from the Services dropdown.
2. Create a table manually called **orders** in the a database named **labs** through Athena's utility:
<br/>![alt text](/images/CreateManualTable.png)</br>
### Orders Schema
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
SHOW CREATE TABLE labs.orders
```

More resources:
- [Athena Supported Formats](http://docs.aws.amazon.com/athena/latest/ug/supported-formats.html)
- [Athena Language Reference](http://docs.aws.amazon.com/athena/latest/ug/language-reference.html)

Congratulations, you queried your first S3 file through Amazon Athena!
<hr/></br>

# Introducing Glue and Athena
One of the many benefits of Glue, is its ability to discover and profile data from S3 Objects. This become handy in quickly creating a catalog of new and incoming data.
To get started:
1. In Athena, from the **Database** pane on the left hand side, click **Create Table** drop down and select **Automatically**
<br />![alt text](/images/CreateAutomaticTable.png)<br/>
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

- Remember, you have the ability to **Save a query** for future re-use and reference.
<hr/></br>

# Breakout Exercises

## Breakout 1 - Load B2B Dataset

Now that we have learned about crawlers, lets put it to use to load the rest of our [B2B Orders](https://slalom-seattle-ima.s3-us-west-2.amazonaws.com/docs/B2B%20Dataset.zip) dataset.

- Unzip the data, and upload it to your S3 Bucket **remember, one folder represents one table.**
- Run a crawler through your bucket to discovery the dataset.
- Add new tables to the **labs** database with prefix "**b2b_**"

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

## Breakout 2 - Discover Instacart Data
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
<hr/></br>

# Visualizing and Dashboarding with QuickSight

## Getting the data

Open QuickSight and **choose 'Manage Data'** in the upper right hand corner.

**Choose 'New Dataset'** and then select **Athena**.

Give it a name and **choose 'Create Data Source'**. Find the database you created earlier which contains the B2B tables and select the b2b_orders table.  Choose 'Edit/Preview Data'.

Now we will join all the tables we had created in Athena by using the Glue data crawler.  Some tables join directly to the Orders table and some join to the Company table.  To join a table to something other than the first one we selected (Orders) drag and drop it on top of the table you want to join it to.  You will then need to define the join clauses - they will all be based on the key which is named after the dimension table you are trying to join.  When you are finished it should look soemthing like this (we will skip the Segment and Product tables as the crawler didn't pick up the headers correctly - we can correct this using a Glue ETL job, but for purposes of this lab we can just leave these two tables out of our new dataset):

![alt text](/images/b2b%20joins.png)

Before we start visualizing, lets also add a couple calculated fields to convert the date fields, order_date and ship_date to date fields rather than strings (normally we could just change the datatype in QuickSight in the data preview window, but Athena does not support this today.  It will soon, and you could do this for any other type of data source, but for Athena we will need to make calculated fields).  On the left side choose 'New Field' and then use the parseDate() function to convert the sting field to a date field.  Use these formulas for each calculated field:
```python
parseDate({order_date},'MM/dd/yyyy')
parseDate({ship_date},'MM/dd/yyyy')
```

 (image of calcs)
 
Great, now we are ready to begin visualizing our data.  By default AutoGraph is chosen as the visual type, which will pick an appropriate visual type depending on the types of fields choose to visualize.  We can leave it like that for now, and later we will specify certain visual types.

First click on 'sales' and we will get a KPI visual type.  Then click on the Field Wells on the top and use the pull down menu to choose 'Show As->Currency':
(format image)

Now click on the 'Order Date' field.  Notice how our visual type automatically is changed to a line chart.  It will default to the Year level, but use the pull down menu on the Order Date field to choose 'Aggregate->Month', or you can do the same thing by clicking on the Order Date label on the x-axis:
(month image)

Next click the pull down menu on the segment field in the list of measures and choose 'Convert to dimension'.  Then find it in the list of dimensions and select it.  Now we will have 3 lines in our line chart, one per segment.  Expand the axis range on the bottom of the visual to see the whole trend:
(image of convert field)
(image of line chart)

Great, we have our first visual!  Now let's add another visual using the '+' button in the upper left and selecting 'Add visual':
(add visual image)

For our next visual, let's start by clicking 'industry_name' and 'sales'.  We will get a bar chart sorted in descending order by sales:
(industry image)

Let's add a drill down capability for our end users by dragging the 'company_name' field just below the 'industry_name' field on the  Y axis.  You should see a notification that says 'Add drill-down layer':
(drill down image)

Cool, now our end users will be able to drill down from Industry to the actual Companies in that industry.  You can see how this works by clicking on one of the bars and selecting 'Drill down to company_name':

If you want to drill back up, you can either click the bars again or you can use the icons in the upper right to either drill one level back up or all the way back to the top (if you have more than one drill down built in):

Next let's change the visual type to a Treemap using the Visual Types selector in the bottom left:
(treemap image)

Now add another visual to the dashboard.  This one will be a very granular table of all the order details.  First select the 'Pivot Table' visual type.  Then click on the company_name dimension.  Expand the Field Wells on top and drag the order_id to the Rows underneath the company_name:
(add field to pivot)

Also click on the product_id, ship_mode, sales, profit, and quantity fields to add more detail to our visual.  It should look something like this:
(table image)

Great, our dashboard is starting to shape up.  We can now add some KPI visuals across the top to provide some high-level summary information for our users.  Add another visual and select the 'sales' field.  Expand the Field Wells and drag the Order Date to the 'Trend group' field well.  Let's also resize the visual by dragging the bottom right corner of the visual to make it smaller.  Drag it to the top of the dashboard by grabbing the dotted area on the top of the visual.  Once you have it on the top it should look like this:
(sales kpi visual)

Let's repeat this last step to add two more KPI's to the top of the dashboard.  After you add another visual, select the KPI visual type in the lower left of the screen:
(kpi visual tyep image)

The second one will be a KPI for the number of unique orders YoY.  To do this, select the KPI visual type and drag 'order_id' to the 'Value' field well and 'Order Date' to the 'Trend group' field well.  Change the aggregation on 'order_id' from Count to Count Distinct:
(orders KPI image)


For the third KPI, let's show a YoY trend of the average order size.  Click 'sales' and then use the pull down menu on the field to change the aggregation to Average.  Add the 'Order Date' to the 'Trend group' field well like we did for the first KPI:
(avg sales image)

You can optionally play around with the KPI formatting options.  You can change the primary number that is displayed and the comparison type.  You can also choose if you would like to show the trend arrows as well as the progress bar (which is displayed as a bullet chart on the bottom of the KPI).
(kpi formatting image)

Lastly let's edit the titles of the KPI's to be more user friendly.  I chose 'Sales YoY', 'Avg Order Size YoY', and '# of Orders YoY' for my titles:
(kpi complete image)

Awesome!  Our dashboard is looking really good.  We are almost ready to share it with the rest of our end users.  Just before we do that, let's add a filter (or many) for our users to leverage.  On the left, choose 'Filter' and then either click 'Create one' or the little filter icon on the top and choose 'Order Date'.  I like to use the 'Relative dates' type of UI for my date filters.  Set it to the 'Last 5 years' and hit 'Apply'.  Lastly click on the top where it says 'Only this visual' and change it to 'All visuals' so that it applies to the entire dashboard:
(date filter image)
(all visuals image)

We are ready to share our dashboard with the rest of our users now!  Click the 'Share' button in the upper right of the screen and select 'Create Dashboard'. Give it a name like 'Sales Dashboard' and choose 'Create Dashboard'.  
(create dash image)

On the next screen you will be able to share it with other users in your QuickSight account.  Once you add them you can click 'Share' and it will send them an email saying a dashboard has been shared with them.  Also the next time they log into QuickSight they will see it in the list of dashboards they have access to.

Great job!  You have just created your first dashboard to be shared with the rest of your team!



## SPICE 

blablabal 

### the end

