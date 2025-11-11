2 types of varaibles in DBT

1 - Jinja variable
2 - DBT variables

1 - Jinja Variables

{% macro learn_variables() %}
    {% set your_name = 'Ankur' %}
    {{ log("Hello! " ~ your_name, info=True) }}
{% endmacro %}
-----------------------------------------------------
2 - 
{% macro learn_variables() %}
    {% set your_name = 'Ankur' %}
    {{ log("Hello! " ~ your_name, info=True) }}

    {{ log ("Hello !" ~ var("dbt_user_name") ~ " How are you?", info = True)}}
{% endmacro %}

run the command:

dbt run-operation learn_variables --vars '{dbt_user_name: Ankur form DBT}'
dbt run-operation learn_variables --vars "{""dbt_user_name"": ""Ankur from command line""}"
-----------------------------
3 - Setting default variable:

var("dbt_user_name","no user name is sent")

Or can be sent in project.yml

vars:
  dbt_user_name: "Ankur from project.yml"
  
---------------------------------
make changes in fact_reviews.SQL

{% if is_incremental() %}
    {% if var("start_date", False) and var("end_date", False) %}
        {{ log('Loading ' ~ this ~ ' incrementally (start_date: ' ~ var("start_date") ~ ', end_date: ' ~ var("end_date") ~ ')', info=True) }}
        where review_date >= '{{ var("start_date") }}'
        AND review_date < '{{ var("end_date") }}'
    {% else %}
        where review_date > (select max(review_date) from {{ this }})
        {{ log('Loading ' ~ this ~ ' incrementally (all missing dates)', info=True)}}
    {% endif %}
{% endif %}





dbt run -s fact_reviews --vars "{""start_date"": ""2025-11-10 00:00:00"", ""end_date"": ""2025-11-10 23:59:59""}"
