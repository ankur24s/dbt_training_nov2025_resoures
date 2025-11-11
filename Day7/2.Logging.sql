Create one macro

Magic of {{log}}

{% macro learn_logging() %}
    {{log('call you mom')}}
{% endmacro %}

dbt run-operation learn_logging


---------------------------------

Now to pop up on the screen with info=True

{% macro learn_logging() %}
    {{log('call you dad', info=True)}}
{% endmacro %}

-----------------------------
Disabling log or comments

--{# #}