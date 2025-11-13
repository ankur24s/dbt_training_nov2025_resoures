--Test if product unit price is equal to orderamount/quantity
select 
    order_id,product_id,product_unit_price,quantity,order_amount
from {{ ref('fact_sales') }}
where product_unit_price !=(order_amount/quantity)