{{
    config(materialized = 'table')
}}

SELECT product_id
, name as product_name
, price
, inventory as inventory_quantity
from {{source ('postgres', 'products')}}