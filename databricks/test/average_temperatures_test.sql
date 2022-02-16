-- Databricks notebook source
-- MAGIC %python
-- MAGIC # Data set up
-- MAGIC # Load the test data from a file
-- MAGIC # This can also be done using dataframe API for smaller datasets
-- MAGIC df = spark.read.parquet("/FileStore/test/stationData_test.parquet")
-- MAGIC df.createOrReplaceTempView("TEMP_DATA")

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW RAW_STATION_DATA  AS (
  SELECT * FROM TEMP_DATA
)

-- COMMAND ----------

-- Prep data by calling the transformation function

-- COMMAND ----------

-- MAGIC %run ../main/functions/normalize-temps-and-zones

-- COMMAND ----------

-- MAGIC %run ../main/functions/monthly-average-temparature

-- COMMAND ----------

-- Output from above function is stored in a temp table called STATION_DATA
-- Assertions:
-- We do not expect any errors. Hence number of records in output must be equal to number of records in input

-- COMMAND ----------

-- Assertion #1: For the test data, the month 4 avg temp should be 14.1. Assert on that
-- Create a temp view so that results of this unit test case can be examined.
 CREATE OR REPLACE TEMP VIEW UNIT_TEST_RESULT AS (
  SELECT
  'Average temparatures' AS TEST_FUNCTION,
  'Monthly average' AS TEST_NAME,
  CURRENT_TIMESTAMP() AS RUNTIME,
  IF(AVG_TEMP = 14.1, 'PASS', 'FAIL')
  FROM MONTHLY_AVG_TEMPARATURE WHERE MONTH=4
);

-- Insert into the overall test results table
INSERT INTO CI_BUILD.TEST_RESULTS (SELECT * FROM UNIT_TEST_RESULT);