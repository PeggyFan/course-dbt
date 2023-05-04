with order_products as (
    select * from {{ ref('int_user_order_products')}}
)

, product_orders_agg as (
    select
        product_id
        ,product_name
        ,order_date
        ,count(distinct user_id) as users
        ,count(distinct order_id) as orders
        ,sum(quantity) as units
        ,sum(case when discount_pct is not null then 1 else 0 end) as promo_orders
        ,sum(revenue) as revenue
    from order_products
    group by 1,2,3
)

select 
        {{ dbt_utils.generate_surrogate_key([
                'order_date', 
                'product_id'
            ])
        }} as unique_key,
        *
from product_orders_agg 