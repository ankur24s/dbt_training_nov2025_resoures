{{
  config(
    schema = 'transform',
    materialized='incremental',
    incremental_strategy = 'delete+insert',
    unique_key = 'product_id',
  )
}}

with products as (
    select * from {{ ref('products_snapshot') }}
     where dbt_valid_to is null
)
select
    product_id as product_id,
    trim(product_name) as product_name, 
    unit_price as unit_price,
    created_date as created_date,
    lastmodified_date as lastmodified_date
from products

{% if is_incremental() %}

    where lastmodified_date > (select max(lastmodified_date) from {{ this }})

{% endif %}

