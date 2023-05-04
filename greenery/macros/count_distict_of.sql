{% macro count_distinct_of(col_name, val) %}

count( distinct case when {{ col_name }} = '{{ val }}' then user_id end)

{% endmacro %}