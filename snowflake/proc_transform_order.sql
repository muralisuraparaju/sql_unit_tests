-- Stored procedure that transforms raw order data: We need:
-- 1. The priority number as a separate column. (parsed from a format of 1-HIGH/..)
-- 2. The clerk employee id as a number (parsed from a format of Clerk-00111/..) 
-- Input table:  ORDERS (not passed explicitly, used within the query as we do not expect the same logic for another table)
-- Output table: TRANSFORMED_ORDERS (a temporary table)
CREATE OR REPLACE PROCEDURE TRANSFORM_ORDER_DATA()
    RETURNS STRING
    LANGUAGE SQL
    AS    
        BEGIN  
            CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TRANSFORMED_ORDERS AS (
                SELECT O_ORDERKEY, O_CUSTKEY, O_ORDERSTATUS, O_TOTALPRICE, O_ORDERDATE, 
                O_ORDERPRIORITY, SUBSTR(O_ORDERPRIORITY, 1, 1) AS ORDER_PRIORITY_CODE, SUBSTR(O_ORDERPRIORITY, 3) AS ORDER_PRIORITY_NAME,
                SUBSTR(O_CLERK, 7) AS O_CLERK_ID,
                O_CLERK, O_SHIPPRIORITY, O_COMMENT FROM OUR_FIRST_DB.PUBLIC.RAW_ORDERS            
            );
            RETURN 'SUCCESS';
        EXCEPTION
            WHEN statement_error THEN
                RETURN object_construct('Error type', 'STATEMENT_ERROR',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
        END;
        