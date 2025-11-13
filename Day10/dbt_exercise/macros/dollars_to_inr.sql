{% macro dollars_to_inr(column_name, scale=2) %}
    ({{ column_name }} * 82.89)::numeric(16, {{ scale }})
{% endmacro %}
