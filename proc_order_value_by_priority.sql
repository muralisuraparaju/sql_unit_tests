-- Stored procedure that aggregates the order data: We need:
-- 1. Total order value by the priority
-- Input table:  TRANSFORMED_ORDERS (Temporary table created by a previous transformation table)
-- Output table: ORDER_VALUE_BY_PRIORITY (a Temporary table to hold results)
CREATE OR REPLACE PROCEDURE COMPUTE_ORDER_VALUE_BY_PRIORITY()
    RETURNS STRING
    LANGUAGE SQL
    AS    
        BEGIN  
            CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.ORDER_VALUE_BY_PRIORITY AS (
                SELECT ORDER_PRIORITY_NAME, SUM(O_TOTALPRICE) AS TOTAL_ORDER_VALUE
                FROM TRANSFORMED_ORDERS GROUP BY (ORDER_PRIORITY_NAME) ORDER BY ORDER_PRIORITY_NAME
            );
            RETURN 'SUCCESS';
        EXCEPTION
            WHEN statement_error THEN
                RETURN object_construct('Error type', 'STATEMENT_ERROR',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
        END;