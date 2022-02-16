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

-- Run the function under test

-- COMMAND ----------

-- MAGIC %run ../main/functions/normalize-temps-and-zones

-- COMMAND ----------

-- Output from above function is stored in a temp table called STATION_DATA
-- Assertions:
-- We do not expect any errors. Hence number of records in output must be equal to number of records in input

-- COMMAND ----------

-- Assertion #1: ROW counts should match
-- Create a temp view so that results of this unit test case can be examined.
 CREATE OR REPLACE TEMP VIEW UNIT_TEST_RESULT AS (
  WITH TEMP_RESULT AS (
     select COUNT(RAW.STATION) RAW_COUNT,  COUNT(OUTPUT.STATION) OUTPUT_COUNT
     from RAW_STATION_DATA raw, STATION_DATA output  
  )

  SELECT
  'Raw data transform' AS TEST_FUNCTION,
  'Row counts' AS TEST_NAME,
  CURRENT_TIMESTAMP() AS RUNTIME,
  IF(RAW_COUNT = OUTPUT_COUNT, 'PASS', 'FAIL')
  FROM TEMP_RESULT
);

-- Insert into the overall test results table
INSERT INTO CI_BUILD.TEST_RESULTS (SELECT * FROM UNIT_TEST_RESULT);

-- COMMAND ----------

-- Assertion 2: If the average temp in F is 61, avg temp in C should be 16.1 (using teh formula.). We know that Station:USW00093228 for date 2018-05-27
-- Has the avg temp F as 61. Hence Assert on that
 CREATE OR REPLACE TEMP VIEW UNIT_TEST_RESULT AS (
  WITH TEMP_RESULT AS (
     SELECT AVG_TEMP_F,  AVG_TEMP_C
     FROM STATION_DATA output  WHERE STATION='USW00093228' AND DATE='2018-05-27'
  )

  SELECT
  'Raw data transform' AS TEST_FUNCTION,
  'F to C calculation' AS TEST_NAME,
  CURRENT_TIMESTAMP() AS RUNTIME,
  IF(AVG_TEMP_C = 16.1, 'PASS', 'FAIL') AS RESULT
  FROM TEMP_RESULT
);

-- Insert into the overall test results table
INSERT INTO CI_BUILD.TEST_RESULTS (SELECT * FROM UNIT_TEST_RESULT);