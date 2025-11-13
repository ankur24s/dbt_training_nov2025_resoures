{{
  config(
    materialized='incremental',
    incremental_strategy = 'append'
  )
}}

select
    date, 
    month, 
    year, 
    day,
    updated_at
from {{ source('landing','dates')}}

{% if is_incremental() %}

    where updated_at > (select max(updated_at) from {{ this }})

{% endif %}
