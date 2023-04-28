with order_items as (
    select *
    from {{ ref('stg_postgres__orderitems') }}
)
, orders as (
    select *
    from {{ ref('stg_postgres__orders') }}
)
, promos as (
    select * from {{ ref ('stg_postgres__promos') }}   
)
select
    o.user_id
    , o.order_id
    , p.discount_pct
    , o.created_at
    , oi.product_id
    , oi.quantity
from order_items oi
left join orders o
    on o.order_id = oi.order_id
left join promos p 
    on o.promo_id = p.promo_id