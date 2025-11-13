{% snapshot products_snapshot_check %}

  {{
      config(
        unique_key="product_id",
        strategy='check',
        check_cols='all'
      )
  }}

select
    product_id as product_id,
    product_name as product_name,
    unitprice as unit_price,
    created_date as created_date,
    lastmodified_date as lastmodified_date
from {{ source('landing','products') }}

{% endsnapshot %}