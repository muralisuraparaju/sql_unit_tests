# Databricks notebook source
df = spark.read.parquet("/mnt/training/weather/StationData/stationData.parquet")
df.createOrReplaceTempView("RAW_STATION_DATA")