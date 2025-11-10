https://hub.getdbt.com/

---------------
SELECT 
    l.listing_id,
    l.listing_name,
    l.room_type,
    l.minimum_nights,
    l.price,
    l.host_id,
    h.host_name,
    h.is_superhost as host_is_superhost,
    l.created_at,
    GREATEST(l.updated_at, h.updated_at) as updated_at
FROM ( 
{{dbt_utils.deduplicate(ref('dim_listings'),'listing_id','updated_at')}} 
)l
LEFT JOIN {{ref('dim_hosts')}}  h ON (h.host_id = l.host_id)
-------------

Assignemnt:

Use the generic test 

accepted_range in your project

accepted_range(model, column_name, min_value=none, max_value=none, inclusive=true)

dim_host > price  (price should be in this range = 
100 to 7500)
-----------------------------------------------------------------------

some test config missed -

data_tests:
  +store_failures: true
  