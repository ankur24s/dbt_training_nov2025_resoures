{{
  config(
    schema = 'consumption',
    materialized='view'
  )
}}

select
   sales.order_id as order_id,
   sales.product_id as product_id,
   sales.customer_id as customer_id,
   sales.order_date as order_date,
   sales.order_amount as order_amount,
   sales.order_amount_in_inr as order_amount_in_inr,
   sales.created_date as created_date,
   sales.quantity as quantity,
   dim_products.product_name  as product_name ,
   dim_products.unit_price as product_unit_price,
   dim_customers.customer_name as customer_name,
   dim_customers.country  as country,
   sales.lastmodified_date  
from {{ ref('int_sales') }} sales
left join {{ ref('dim_products')}} dim_products
 on sales.product_id=dim_products.product_id
left join {{ ref('dim_customers')}} dim_customers
  on sales.customer_id = dim_customers.customer_id

