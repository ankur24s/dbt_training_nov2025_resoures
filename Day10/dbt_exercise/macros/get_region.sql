{% macro get_region(country) %}
    {%- set apac_countries = ('Bhutan', 'British Indian Ocean Territory (Chagos Archipelago)') -%}
    {%- set emea_countries = ('Greenland', 'Equatorial Guinea', 'Greece', 'Lesotho', 'Iran', 'Antarctica') -%}
    {%- set latam_countries = ('Antigua and Barbuda', 'Uruguay') -%}
    {%- set na_countries = ('United States of America', 'Canada') -%}
    case 
        when {{ country }} in {{ apac_countries }} then '{{ var('apac') }}'
        when {{ country }} in {{ emea_countries }} then '{{ var('emea') }}'
        when {{ country }} in {{ latam_countries }} then '{{ var('latam') }}'
        when {{ country }} in {{ na_countries }} then '{{ var('na') }}'
    end
{% endmacro %}