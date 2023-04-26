
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
, events1 as (
    select
        product_id
        ,session_id
        ,min(created_at)::date as activity_date
        ,sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts_events
        ,sum(case when event_type = 'checkout' then 1 else 0 end) as checkouts_events
        ,sum(case when event_type = 'packaged_shipped' then 1 else 0 end) as package_shippeds_events
        ,sum(case when event_type = 'page_view' then 1 else 0 end) as page_views_events
    from events
    group by 1,2
)
, events2 as (
  select *
  , BOOL_OR 



)
select {{ dbt_utils.generate_surrogate_key([
                'activity_date', 
                'product_id'
            ])
        }} as unique_key,
        * 
from final

