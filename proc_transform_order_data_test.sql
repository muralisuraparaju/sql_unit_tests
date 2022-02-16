CREATE OR REPLACE PROCEDURE TRANSFORM_ORDER_DATA_TEST()
    RETURNS STRING
    LANGUAGE SQL
    AS    
        BEGIN
            CALL OUR_FIRST_DB.PUBLIC.TRANSFORM_ORDER_DATA();
            CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TRANSFORM_DATA_TEST_RESULT AS (
                WITH PRIORITY_NAMES AS
                    (SELECT COUNT(ORDER_PRIORITY_NAME) AS BAD_RECORDS 
                        FROM OUR_FIRST_DB.PUBLIC.TRANSFORMED_ORDERS WHERE ORDER_PRIORITY_NAME NOT IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT', 'NOT SPECIFIED'))

                SELECT 
                    'Raw data transform' AS TEST_FUNCTION,
                    'Check priority names' AS TEST_NAME,
                    CURRENT_TIMESTAMP() AS RUNTIME,
                    IFF(BAD_RECORDS = 0, 'PASS', 'FAIL') AS STATUS 
                    FROM PRIORITY_NAMES
            );
            
            INSERT INTO OUR_FIRST_DB.PUBLIC.UNIT_TEST_RESULTS (SELECT * FROM OUR_FIRST_DB.PUBLIC.TRANSFORM_DATA_TEST_RESULT); 
            
            RETURN 'SUCCESS';
        EXCEPTION
            WHEN statement_error THEN
                RETURN object_construct('Error type', 'STATEMENT_ERROR',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
        END;