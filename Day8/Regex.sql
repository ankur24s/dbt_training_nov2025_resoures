


Update source.yml

- name: listings
        identifier: src_listings
        columns:
          - name: price
            tests:
              - dbt_expectations.expect_column_values_to_match_regex:
                  regex: "\\\\$[0-9]+\\\\.[0-9]+$"







select * from dev.bronze_airbnb.src_listings


$ numericcha /.

$.343
$[0-9][0-9.]


 SELECT REGEXP_INSTR(price, '\\$[0-9][0-9\\.]+$') AS position, price
  from dev.bronze_airbnb.src_listings


 select
regexp_instr(price, '\\$[0-9][0-9\\.]+$', 1, 1, 0, '') > 0
 as expression
    from DEV.bronze_airbnb.src_listings
  
 SELECT REGEXP_INSTR(price, '\\$') AS position, price
  from dev.bronze_airbnb.src_listings
;







    with grouped_expression as (
    select
regexp_instr(price, '\$[0-9][0-9\.]+$', 1, 1, 0, '') > 0
 as expression
    from DEV.bronze_airbnb.src_listings
),
validation_errors as (
    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)
select *
from validation_errors







 SELECT REGEXP_INSTR('$4584.2832.232.23.232.233232', '\\$[0-9][0-9\\.]+$') AS position

 
 SELECT REGEXP_INSTR('$4584.283', '\\$[0-9]+\\.[0-9]+$') AS position



'\\$[0-9]+\\.[0-9]+$'


'\\\\$[0-9]+\\\\.[0-9]+$'