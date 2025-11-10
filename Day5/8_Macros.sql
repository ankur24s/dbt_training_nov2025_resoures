MACROS

CUSTOM GENERIC TESTS

--The contents of macros/positive_value.sql

{% test positive_value(model, column_name) %}
SELECT
 *
FROM
 {{ model }}
WHERE
 {{ column_name}} < 1
{% endtest %}


----------------