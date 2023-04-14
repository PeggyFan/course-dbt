{{
    config(materialized='table')
}}

SELECT user_id
, address_id
, created_at
, updated_at
, email
, first_name
, last_name
, phone_number
FROM {{ source('postgres', 'users') }}