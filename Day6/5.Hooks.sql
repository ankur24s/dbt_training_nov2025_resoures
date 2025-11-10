clean-targets:
  - "target"

on-run-start:
  - "CREATE TABLE IF NOT EXISTS {{ target.schema }}.audit_log ( model_name STRING, run_timestamp TIMESTAMP )"

models:
  dbt_training_nov_2025:
    +post-hook:
      - "INSERT INTO {{ target.schema }}.audit_log VALUES ('{{ this }}', CURRENT_TIMESTAMP)"