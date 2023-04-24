with orders as (
    select * from {{ ref('stg_postgres__orders')}}
)
, order_items as (
    select * from {{ ref('stg_postgres__orderitems')}}
)
, promos as (
    select * from {{ ref ('stg_postgres__promos') }}   
)
, product_orders_agg as (
    select
        oi.product_id
        ,o.created_at as order_date
        ,count(distinct o.order_id) as orders
        ,sum(oi.quantity) as units
        ,sum(case when p.promo_id is not null then 1 else 0 end) as promo_orders
    from orders o
    join order_items oi
    on o.order_id = oi.order_id 
    left join promos p on p.promo_id = o.promo_id
    group by 1,2
)

select 
        {{ dbt_utils.generate_surrogate_key([
                'order_date', 
                'product_id'
            ])
        }} as unique_key,
        *
from product_orders_agg 