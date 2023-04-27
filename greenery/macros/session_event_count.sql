{% macro session_event_count(event_type) %}
    select session_id
        , min(created_at)::date as activity_date
        , sum(case when '{{event_type}}' = 'checkout' then 1 else 0 end) as checkout_events
        , sum(case when'{{event_type}}' = 'package_shipped' then 1 else 0 end) as package_shipped_events
        , sum(case when '{{event_type}}' = 'page_view' then 1 else 0 end) as page_view_events
        , sum(case when '{{event_type}}' = 'add_to_cart' then 1 else 0 end) as add_to_cart_events
        from {{ ref('stg_postgres__events') }}
    group by 1
{% endmacro %}

