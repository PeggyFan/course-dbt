{{
    config(materialized = 'table')
}}

select event_id
, session_id
, user_id
, e.order_id
, coalesce(e.product_id, oi.product_id) as product_id
, page_url
, created_at
, event_type
FROM {{ source('postgres', 'events') }} e 
left join {{ source('postgres', 'order_items') }} oi 
on e.order_id = oi.order_id
