
with activity_daily as (
    select 
    session_started_ts_utc::date as activity_date
    , count(distinct case when page_view > 0 then session_id else null end) as page_view_sessions
    , count(distinct case when add_to_cart > 0 then session_id else null end) as add_to_cart_sessions
    , count(distinct case when checkout > 0 then session_id else null end) as checkout_sessions
    , count(distinct session_id) as total_sessions
    from {{ ref('int_sessions_product_daily') }}
    group by 1
)
select *
from activity_daily
