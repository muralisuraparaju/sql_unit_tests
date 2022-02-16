-- Databricks notebook source
CREATE DATABASE IF NOT EXISTS CI_BUILD;
CREATE TABLE IF NOT EXISTS CI_BUILD.TEST_RESULTS (
   TEST_FUNCTION STRING, 
   TEST_NAME STRING,
   RUNTIME TIMESTAMP,
   RESULT STRING
);

-- COMMAND ----------

-- This is optional. If results need to be retained for a longer period, do not truncate
TRUNCATE TABLE CI_BUILD.TEST_RESULTS;

-- COMMAND ----------

-- MAGIC %run ./data_transformation_test

-- COMMAND ----------

-- MAGIC %run ./average_temperatures_test

-- COMMAND ----------

-- MAGIC %sql
-- MAGIC SELECT * FROM CI_BUILD.TEST_RESULTS;