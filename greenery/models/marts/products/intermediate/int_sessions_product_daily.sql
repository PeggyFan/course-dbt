
-- On average, how many unique sessions do we have per hour?
{{ 
    config(
        materialized='table'
    )
}}

with events as (
    select * 
    from {{ ref ('stg_postgres__events') }}
)

, final as (
    select
        product_id
        ,created_at::date as activity_date
        ,sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts
        ,sum(case when event_type = 'checkout' then 1 else 0 end) as checkouts
        ,sum(case when event_type = 'packaged_shipped' then 1 else 0 end) as package_shippeds
        ,sum(case when event_type = 'page_view' then 1 else 0 end) as page_views
        ,count(distinct case when event_type = 'add_to_cart' then user_id else null end) as add_to_carts_users
        ,count(distinct case when event_type = 'checkout' then user_id else null end) as checkouts_users
        ,count(distinct case when event_type = 'packaged_shipped' then user_id else null end) as package_shippeds_users
        ,count(distinct case when event_type = 'page_view' then user_id else null end) as page_views_users
    from events
    group by 1,2
)

select {{ dbt_utils.generate_surrogate_key([
                'activity_date', 
                'product_id'
            ])
        }} as unique_key,
        * 
from final

