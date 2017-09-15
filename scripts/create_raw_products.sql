CREATE EXTERNAL TABLE `raw_products`(
  `product_id` bigint,
  `product_name` bigint,
  `aisle_id` string,
  `department_id` bigint)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
STORED AS INPUTFORMAT
  'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://royon-customer-public/instacart/products'
