The contents of macros/no_nulls_in_columns.sql :

{% test no_nulls_in_columns(model) %}
 SELECT * FROM {{model}} WHERE
 {% for col in adapter.get_columns_in_relation(model) -%}
 {{ col.column }} IS NULL OR
 {% endfor %}
 FALSE
{% endtest %}


models:
  - name: dim_listings
    tests:
      - no_nulls_in_columns
----------------------------------------
generate_hash_key_args.sql

{% macro generate_hash_key_args(args) %}
      md5(
	  concat_ws('-', 
				{% for arg in args %}
					{{ arg }}
                    {% if not loop.last %}
							, 
					{% endif %}
				{% endfor %}
			)
	)
{% endmacro %}

Changes in fact_reviews.sql:

select 
{{
generate_hash_key_args(['listing_id','review_date', 'reviewer_name', 'review_text','review_sentiment'])
}} as review_id,
 * 
from  {{ref('silver_reviews')}}

on_schema_change = 
   --adds new columns without backfilling existing rows
	'ignore' — (default) ignore schema changes silently (your current behavior)
	'fail' — throw an error if schema changed (like you expected)
	'append_new_columns' — adds new columns without backfilling existing rows
	'sync_all_columns' — adds columns and syncs order & data types
-----------------------------------------
dbt run -s fact_reviews --full-refresh