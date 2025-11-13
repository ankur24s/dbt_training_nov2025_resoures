{{
  config(
    schema = 'transform',
    materialized='incremental',
    incremental_strategy='merge',
	  unique_key = 'order_id'
  )
}}

select
   order_id as order_id,
   product_id as product_id,
   customer_id as customer_id,
   order_date as order_date,
   order_amount as order_amount,
   {{ dollars_to_inr('order_amount') }} as order_amount_in_inr,
   created_date as created_date,
   quantity as quantity,
   lastmodified_date  
from {{ ref('raw_sales') }}

{% if is_incremental() %}

    where lastmodified_date > (select max(lastmodified_date) from {{ this }})

{% endif %}

