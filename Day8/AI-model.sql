select  *  from DEV.GOLD_AIRBNB.DIM_LISTINGS;

SELECT
  COLUMN_NAME,
  DATA_TYPE,
  COMMENT from  dev.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'GOLD_AIRBNB'
  AND TABLE_NAME   = 'DIM_HOSTS';

COMMENT ON TABLE dev.GOLD_AIRBNB.DIM_HOSTS IS 'Host dimension table containing Airbnb host details';
COMMENT ON COLUMN dev.GOLD_AIRBNB.DIM_HOSTS.HOST_ID IS 'Unique identifier for each host';
COMMENT ON COLUMN dev.GOLD_AIRBNB.DIM_HOSTS.HOST_NAME IS 'Name of the host';
COMMENT ON COLUMN dev.GOLD_AIRBNB.DIM_HOSTS.CREATED_AT IS 'Timestamp when host was created';

SELECT 
    'COMMENT ON COLUMN ' || table_schema || '.' || table_name || '.' || column_name || 
    ' IS ''<add description for ' || column_name || ' here>'';' AS generated_sql
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'GOLD_AIRBNB'
  AND table_name = 'DIM_HOSTS'
ORDER BY ordinal_position;


DECLARE DB STRING DEFAULT 'DEV';
DECLARE SC STRING DEFAULT 'GOLD_AIRBNB';
DECLARE TB STRING DEFAULT 'DIM_HOSTS';
DECLARE MODEL STRING DEFAULT 'snowflake-arctic';

BEGIN
    FOR rec IN (
        SELECT COLUMN_NAME, DATA_TYPE
        FROM TABLE(INFORMATION_SCHEMA.COLUMNS)
        WHERE TABLE_CATALOG = DB
          AND TABLE_SCHEMA  = SC
          AND TABLE_NAME    = TB
        ORDER BY ORDINAL_POSITION
    )
    DO
        LET prompt STRING := 
            'You are a data analyst. Write a short, business-friendly description for a column '
            || 'named "' || rec.column_name || '" with datatype "' || rec.data_type || '" '
            || 'from table ' || DB || '.' || SC || '.' || TB || '. '
            || 'Do not repeat the column name in the description.';

        LET ai_text STRING :=
            SNOWFLAKE.CORTEX.COMPLETE(
                MODEL,
                prompt
            );

        EXECUTE IMMEDIATE
           'COMMENT ON COLUMN ' || DB || '.' || SC || '.' || TB || '.' || rec.column_name ||
           ' IS ' || QUOTE(ai_text);

        -- print the result to console
        LET msg STRING := 'Updated column: ' || rec.column_name || ' → ' || ai_text;
        CALL SYSTEM$LOG_INFO(msg);

    END FOR;
END;


------
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

SELECT SNOWFLAKE.CORTEX.COMPLETE('snowflake-arctic', 'Test message');



SELECT
  COLUMN_NAME,
  DATA_TYPE,
  COMMENT from  dev.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'BRONZE_AIRBNB'
  AND TABLE_NAME   = 'SRC_HOSTS';

  
COMMENT ON TABLE dev.BRONZE_AIRBNB.SRC_HOSTS IS 'Host dimension table containing Airbnb host details';

COMMENT ON COLUMN dev.BRONZE_AIRBNB.SRC_HOSTS.name IS 'name of the host having listing in airbnb';



SELECT SNOWFLAKE.CORTEX.COMPLETE('snowflake-arctic', 'Test message');

-----------------

ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';   -- important

SELECT SNOWFLAKE.CORTEX.COMPLETE('snowflake-arctic', 'Test message');

----------------------------------

SELECT
  COLUMN_NAME,
  DATA_TYPE,
  COMMENT from  dev.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'GOLD_AIRBNB'
  AND TABLE_NAME   = 'DIM_LISTINGS';