-- Sets up a temporary table from the actual data source. This is one approach
-- SNOWFLAKE does not support synonyms. Hence we create a temporary table.
-- Another approach could be just creating a temporary table with the same name as the main table 
-- in unit test case that masks the actual table name
-- This can cause confusion between the actual table name and the overriding table name
CREATE OR REPLACE PROCEDURE MAIN_DATASETUP()
    RETURNS STRING
    LANGUAGE SQL
AS
    BEGIN
        CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.RAW_ORDERS AS (SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS);
    END;
    