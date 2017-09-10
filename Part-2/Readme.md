# Part 2 - Automating Table Creation

## References

1. [AWS Glue API documentation](http://docs.aws.amazon.com/glue/latest/dg/aws-glue-api.html)
2. [Setting up IAM Permissions for AWS Glue](http://docs.aws.amazon.com/glue/latest/dg/getting-started-access.html)

## Prerequisits

1. Create an [AWS account](https://aws.amazon.com/free/)

## Setup IAM Permissions for AWS Glue
#### Alternatively, you can run the [CloudFormation Template](cf_createIAMRole_GlueServiceRole.json) in this folder cf_createIAMRole_GlueServiceRole.json
1. Access the IAM console and select **Users**.  Then select your username
2. Click **Add Permissions** button
3. From the list of managed policies, attach the following:
  - AWSGlueConsoleFullAccess
  - CloudWatchLogsReadOnlyAccess
  - AWSCloudFormationReadOnlyAccess

## Setup AWS Glue default service role

1. From the IAM console click **Roles** and create a new role
2. Name it **AWSGlueServiceRole**.  If you choose a different name you will need to manually create a new policy.
3. Select the **AWS Glue Service Role** from the **AWS Service Role** list

1. From the list of managed policies, attach the following:
  - AWSGlueServiceRole
  - AWSGlueServiceNotebookRole
  - AmazonS3FullAccess

## Creating an Athena Table using Glue Crawler

1. Open the Athena console
2. From the **Database** pane on the left hand side, click **Create Table** drop down and select **Automatically**

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
