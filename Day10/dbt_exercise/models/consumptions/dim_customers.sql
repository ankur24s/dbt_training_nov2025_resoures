{{
  config(
    schema = 'consumption',
    materialized='view'
  )
}}

select
    customer_id,
    customer_name, 
    country, 
    created_date,
    region
from {{ ref('int_customers') }}