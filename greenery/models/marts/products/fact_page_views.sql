
with activity_daily as (
    select product_id
    , activity_date
    , sum(add_to_cart) as add_to_cart 
    , sum(page_view) as page_view
    , sum(checkout) as checkout
    from {{ ref('int_sessions_product_daily') }}
    group by 1,2
),

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
        ,coalesce(ad.page_view,0) product_page_view
        ,coalesce(ad.add_to_cart,0) product_add_to_cart
        ,coalesce(ad.checkout,0) product_checkout
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