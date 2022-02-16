CREATE OR REPLACE PROCEDURE ORDER_VALUE_BY_PRIORITY_TEST()
    RETURNS STRING
    LANGUAGE SQL
    AS    
        BEGIN
            -- Transform the raw data
            CALL OUR_FIRST_DB.PUBLIC.TRANSFORM_ORDER_DATA();
            
            -- Call the order value procedure
            CALL OUR_FIRST_DB.PUBLIC.COMPUTE_ORDER_VALUE_BY_PRIORITY();
            
            -- Assertion #1: All order priority must be present in the output. We expect a count of 5 for this dataset
            CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.ORDER_COUNTS_RESULTS AS (
                WITH ORDER_VALUE_COUNTS AS (
                    SELECT COUNT(ORDER_PRIORITY_NAME) AS PRIORITY_NAME_COUNT FROM OUR_FIRST_DB.PUBLIC.ORDER_VALUE_BY_PRIORITY
                )

                SELECT 
                    'Order value by priority' AS TEST_FUNCTION, 'Order priority counts' AS TEST_NAME,
                    CURRENT_TIMESTAMP() AS RUNTIME, IFF(PRIORITY_NAME_COUNT = 5, 'PASS', 'FAIL') AS STATUS 
                    FROM ORDER_VALUE_COUNTS
            );
            -- Update the unit test results table 
            INSERT INTO OUR_FIRST_DB.PUBLIC.UNIT_TEST_RESULTS (SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDER_COUNTS_RESULTS); 
            
            -- Assertion #2: Urgent order value must be greater than 1000
            CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.ORDER_VALUE_RESULTS AS (
                WITH URGENT_ORDER_VALUE_TOTAL AS (
                    SELECT TOTAL_ORDER_VALUE FROM OUR_FIRST_DB.PUBLIC.ORDER_VALUE_BY_PRIORITY WHERE ORDER_PRIORITY_NAME='URGENT'
                )

                SELECT 
                    'Order value by priority' AS TEST_FUNCTION, 'Order value' AS TEST_NAME,
                    CURRENT_TIMESTAMP() AS RUNTIME, IFF(TOTAL_ORDER_VALUE > 1000, 'PASS', 'FAIL') AS STATUS 
                    FROM URGENT_ORDER_VALUE_TOTAL
            );
            
            INSERT INTO OUR_FIRST_DB.PUBLIC.UNIT_TEST_RESULTS (SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDER_VALUE_RESULTS);             
            
            RETURN 'SUCCESS';
        EXCEPTION
            WHEN statement_error THEN
                RETURN object_construct('Error type', 'STATEMENT_ERROR',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
        END;
        

