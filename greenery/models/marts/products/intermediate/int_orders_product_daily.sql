with order_products as (
    select * from {{ ref('int_user_order_products')}}
)

, product_orders_agg as (
    select
        oi.product_id
        ,o.created_at as order_date
        ,count(distinct o.order_id) as orders
        ,sum(oi.quantity) as units
        ,sum(case when p.promo_id is not null then 1 else 0 end) as promo_orders
    from order_products
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