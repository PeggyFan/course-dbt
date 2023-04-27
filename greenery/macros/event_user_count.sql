{% macro event_user_count(product_id, event_type) %}
    select product_id
    , created_at::date as activity_date
    , count( distinct case when event_type = 'checkout' then user_id end) as checkout_users
    , count( distinct case when event_type = 'package_shipped' then user_id end) as package_shipped_users
    , count( distinct case when event_type = 'page_view' then user_id end) as page_view_users
    , count( distinct case when event_type = 'add_to_cart' then user_id end) as add_to_cart_users
    from {{ ref('stg_postgres__events') }}
    group by 1,2
{% endmacro %}

