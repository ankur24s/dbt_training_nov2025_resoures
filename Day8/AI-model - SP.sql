CREATE OR REPLACE PROCEDURE AUTO_DOC_TABLE(
  DB_NAME STRING,
  SCHEMA_NAME STRING,
  TABLE_NAME STRING
)
RETURNS ARRAY
LANGUAGE SQL
AS
$$
DECLARE
  MODEL STRING := 'snowflake-arctic'; -- change if you need a different model
  results ARRAY := ARRAY_CONSTRUCT();
BEGIN

  FOR rec IN (
    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_CATALOG = DB_NAME
      AND TABLE_SCHEMA  = SCHEMA_NAME
      AND TABLE_NAME    = TABLE_NAME
    ORDER BY ORDINAL_POSITION
  )
  DO
    LET prompt STRING :=
      'You are a data analyst. Write a short, business-friendly description (one sentence) ' ||
      'for a column with name "' || rec.COLUMN_NAME || '" and datatype "' || rec.DATA_TYPE || '" ' ||
      'from table ' || DB_NAME || '.' || SCHEMA_NAME || '.' || TABLE_NAME || '. ' ||
      'Be concise and do not repeat the column name.';

    LET ai_text STRING := SNOWFLAKE.CORTEX.COMPLETE(MODEL, prompt);

    -- Build and execute COMMENT ON COLUMN statement
    EXECUTE IMMEDIATE
      'COMMENT ON COLUMN ' || DB_NAME || '.' || SCHEMA_NAME || '.' || TABLE_NAME || '.' || rec.COLUMN_NAME ||
      ' IS ' || QUOTE(ai_text);

    results := ARRAY_APPEND(results, OBJECT_CONSTRUCT('column', rec.COLUMN_NAME, 'description', ai_text));
  END FOR;

  RETURN results;
END;
$$;

----------------------------------------------------------------------------

ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

SELECT SNOWFLAKE.CORTEX.COMPLETE('snowflake-arctic', 'Test message');

