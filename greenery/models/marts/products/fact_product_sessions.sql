    select 
        e.session_id
        , e.user_id
        , p.product_name
        , e.event_type
        , coalesce(e.product_id, oi.product_id) as product_id
        , min(e.created_at)::date as activity_date
        , min(e.created_at) AS session_started_ts_utc
        , max(e.created_at) AS session_ended_ts_utc
        , sum(oi.quantity) as quantity
        , sum(oi.quantity * p.price) as revenue
    from {{ ref('stg_postgres__events') }} e
    left join {{ ref('stg_postgres__orderitems') }} oi
        on oi.order_id = e.order_id
        and oi.product_id = e.product_id
    left join stg_postgres__products p 
        on e.product_id = p.product_id
    where event_type NOT IN ('package_shipped')
    group by 1, 2, 3, 4, 5