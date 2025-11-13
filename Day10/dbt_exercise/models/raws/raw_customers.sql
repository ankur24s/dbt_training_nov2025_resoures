{{
  config(
    schema = 'raw',
    materialized='view',
    pre_hook="INSERT INTO DBT_DEMO.AUDIT.AUDIT_LOG (INVOCATION_ID,MODEL_NAME,STATUS,START_TIME,END_TIME,USER) 
     VALUES ('{{ invocation_id }}','{{ this.name }}','STARTED',CURRENT_TIMESTAMP,NULL,'{{ target.user }}')",
    post_hook="INSERT INTO DBT_DEMO.AUDIT.AUDIT_LOG (INVOCATION_ID,MODEL_NAME,STATUS,START_TIME,END_TIME,USER)
     VALUES ('{{ invocation_id }}','{{ this.name }}','COMPLETED',NULL,CURRENT_TIMESTAMP,'{{ target.user }}')" 
  )
}}

select  customer_id, 
        name, 
        country, 
        region_id, 
        to_date(created_date) as created_date , 
        to_date(lastmodified_date) as lastmodified_date ,
        current_user as created by
from {{ source('landing','customers')}}

-- Added comment
