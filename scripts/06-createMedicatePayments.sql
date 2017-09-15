CREATE EXTERNAL TABLE default.medicare_payments_2010 (
    BENE_SEX_IDENT_CD int,
    BENE_AGE_CAT_CD int,
    CAR_LINE_ICD9_DGNS_CD string,
    CAR_LINE_HCPCS_CD string,
    CAR_LINE_BETOS_CD int, 
    CAR_LINE_SRVC_CNT int, 
    CAR_LINE_PRVDR_TYPE_CD int,
    CAR_LINE_CMS_TYPE_SRVC_CD int,
    CAR_LINE_PLACE_OF_SRVC_CD string, 
    CAR_HCPS_PMT_AMT decimal,
    CAR_LINE_CNT int
    )
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = ',',
  'skip.header.line.count' = '1'
) LOCATION 's3://slalom-sea-datalake/My-First-Athena-Table/'
TBLPROPERTIES ('has_encrypted_data'='false');
