{% macro generate_sales_metrics(metrics, amount_col) %}
    {%- for metric in metrics -%}
        {%- if metric == 'total' -%}
            sum({{ amount_col }}) as total_sales
        {%- elif metric == 'average' -%}
            avg({{ amount_col }}) as average_sales
        {%- endif -%}
        {%- if not loop.last -%}, {%- endif -%}
    {%- endfor -%}
{% endmacro %}