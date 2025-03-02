{{
    config(materialized = 'table')
}}

with source as (
    select * from {{source('postgres','addresses')}}
    
    )

, renamed_recast as (
    select address_id as address_guid
    , address
    , state
    , lpad(zipcode, 5,9) as zipcode
    , country
from source

)

select * from renamed_recast 