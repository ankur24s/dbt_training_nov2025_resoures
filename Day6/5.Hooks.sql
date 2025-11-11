clean-targets:
  - "target"

on-run-start:
  - "CREATE TABLE IF NOT EXISTS {{ target.schema }}.audit_log ( model_name STRING, run_timestamp TIMESTAMP )"
  - insert into...........


models:
  dbt_training_nov_2025:
	+pre-hook:
	  - ""
    +post-hook:
      - "INSERT INTO {{ target.schema }}.audit_log VALUES ('{{ this }}', CURRENT_TIMESTAMP)"
	  
	  
	  
Assignemtn:

pre-hook and a on-run-end

audit_log -> model_name, run_start_timestamp, run_end_timestamp

output I want:

model_name							run_start_timestamp			run_end_timestamp
dbt_project							2025-11-09 23:57:17.327  								(on-run-start)
DEV.silver_airbnb.silver_hosts		2025-11-09 23:57:17.327									(pre-hook)
DEV.silver_airbnb.silver_hosts									2025-11-09 23:57:18.327		(post-hook)
DEV.silver_airbnb.silver_listings	2025-11-09 23:57:18.349									(pre-hook)
DEV.silver_airbnb.silver_listings								2025-11-09 23:57:19.327		(post-hook)
dbt_project														2025-11-09 23:57:30.327		(on-run-end)