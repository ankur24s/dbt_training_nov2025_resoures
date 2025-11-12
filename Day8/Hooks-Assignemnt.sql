on-run-start:
  - "CREATE TABLE IF NOT EXISTS {{ target.schema }}.audit_log ( model_name STRING, run_start_timestamp TIMESTAMP, run_end_timestamp TIMESTAMP )"
  - "INSERT INTO {{ target.schema }}.audit_log VALUES ('dbt_project', CURRENT_TIMESTAMP,NULL)"
 
on-run-end:
  - "INSERT INTO {{ target.schema }}.audit_log VALUES ('dbt_project', NULL,CURRENT_TIMESTAMP)"
 
 
models:
  dbt_training_nov2025:
    +pre-hook:
      - "INSERT INTO {{ target.schema }}.audit_log VALUES ('{{ this }}', CURRENT_TIMESTAMP,NULL)"
    +post-hook:
      - "INSERT INTO {{ target.schema }}.audit_log VALUES ('{{ this }}',NULL,CURRENT_TIMESTAMP)"
 