
{% set event_types = dbt_utils.get_column_values(
    table=ref('stg_postgres__events'), 
    column='event_type') 
%}

with activity_daily as (
    select product_id
    , activity_date
    , sum(add_to_cart) as add_to_cart_events 
    , sum(page_view) as page_view_events 
    , sum(checkout) as checkout_events 
    from {{ ref('int_sessions_product_daily') }}
    group by 1,2
),
, product_sessions as (
    select product_id
    , min(created_at)::date as activity_date 
    , count(distinct case when page_view > 0 then session_id else null end) as page_view_sessions
    , count(distinct case when add_to_cart > 0 then session_id else null end) as add_to_cart_sessions
    , count(distinct case when checkout > 0 then session_id else null end) as checkout_sessions
    , count(distinct session_id) as total_sessions
    from {{ ref('stg_postgres__events') }}
    group by 1
)

orders_daily as (
    select * from {{ ref('int_orders_product_daily') }}
),

products as (
    select * from {{ ref('dim_products') }}
),


-- to ensure all site and order daily product activities/orders are accounted for
dates_combo as (
    select activity_date, product_id from activity_daily
    union
    select order_date as activity_date, product_id from orders_daily
),

final as ( 
    select
        dc.activity_date
        ,dc.product_id
        ,p.product_name
        ,coalesce(ad.page_view_events,0) page_view_events
        ,coalesce(ad.add_to_cart_events,0) add_to_cart_events
        ,coalesce(ad.checkout_events,0) checkout_events
        ,coalesce(ad.page_view_sessions,0) page_view_sessions
        ,coalesce(ad.add_to_cart_sessions,0) add_to_cart_sessions
        ,coalesce(ad.checkout_sessions,0) checkout_sessions
        ,coalesce(ad.total_sessions,0) total_sessions
        ,coalesce(od.orders,0) as orders
        ,coalesce(od.units,0) as order_units
        ,coalesce(od.units * p.price,0) as order_revenue
    from dates_combo as dc
    left join activity_daily as ad
        on dc.activity_date = ad.activity_date
        and dc.product_id = ad.product_id
    left join orders_daily as od 
        on dc.activity_date = od.order_date
        and dc.product_id = od.product_id
    left join products as p
        on dc.product_id = p.product_id
)

select
        {{ dbt_utils.generate_surrogate_key([
                'activity_date', 
                'product_id'
            ])
        }} as unique_key,
        *
from final

