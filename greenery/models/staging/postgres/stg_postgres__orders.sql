{{
    config(materialized = 'table')
}}

SELECT order_id
, user_id
, promo_id
, address_id
, created_at
, order_cost
, shipping_cost
, order_total
, tracking_id
, shipping_service
, estimated_delivery_at
, delivered_at
, status
, min(created_at::date) over() as min_order_date
, max(created_at::date) over() as max_order_date
FROM {{ source('postgres', 'orders') }}