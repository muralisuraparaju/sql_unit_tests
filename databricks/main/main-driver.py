# Databricks notebook source
# Load raw data from: /mnt/training/weather/StationData/stationData.parquet
# Registered as temp table: RAW_STATION_DATA

# COMMAND ----------

# MAGIC %run ./actual-data-load

# COMMAND ----------

# Normalize the data. OUTPUT: STATION_DATA

# COMMAND ----------

# MAGIC %run ./functions/normalize-temps-and-zones

# COMMAND ----------

#Calculate monthly average temps. OUTPUT: MONTHLY_AVG_TEMPARATURE

# COMMAND ----------

# MAGIC %run ./functions/monthly-average-temparature

# COMMAND ----------

# Calculate monthly avg temps by elevation zone. OUTPUT: MONTHLY_AVG_TEMPARATURE_BY_ELEVATION

# COMMAND ----------

# MAGIC %run ./functions/monthly-avg-temparature-by-elevation

# COMMAND ----------

# Calculate monthly average temps by latitude. OUTPUT: MONTHLY_AVG_TEMPARATURE_BY_LATITUDE

# COMMAND ----------

# MAGIC %run ./functions/monthly-avg-temparature-by-latitude

# COMMAND ----------

# Calculate the daily temparature variance for each station. OUTPUT: DAILY_TEMPARATURE_VARIANCE

# COMMAND ----------

# MAGIC %run ./functions/daily-temparature-variance

# COMMAND ----------

# Store the outputs

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE SCHEMA IF NOT EXISTS WEATHER;
# MAGIC USE WEATHER;

# COMMAND ----------

# MAGIC %sql
# MAGIC -- A SIMPLE CREATE, BUT CAN BE A MERGE STATEMENT
# MAGIC CREATE OR REPLACE TABLE WEATHER.STATION_DATA AS SELECT * FROM STATION_DATA;
# MAGIC CREATE OR REPLACE TABLE WEATHER.MONTHLY_AVG_TEMPARATURE AS SELECT * FROM MONTHLY_AVG_TEMPARATURE;
# MAGIC CREATE OR REPLACE TABLE WEATHER.MONTHLY_AVG_TEMPARATURE_BY_ELEVATION AS SELECT * FROM MONTHLY_AVG_TEMPARATURE_BY_ELEVATION;
# MAGIC CREATE OR REPLACE TABLE WEATHER.MONTHLY_AVG_TEMPARATURE_BY_LATITUDE AS SELECT * FROM MONTHLY_AVG_TEMPARATURE_BY_LATITUDE;
# MAGIC CREATE OR REPLACE TABLE WEATHER.DAILY_TEMPARATURE_VARIANCE AS SELECT * FROM DAILY_TEMPARATURE_VARIANCE;