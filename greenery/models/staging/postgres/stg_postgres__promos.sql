{{
    config(materialized='table')
}}

SELECT promo_id
, discount AS discount_pct
, status
FROM {{ source('postgres', 'promos') }}