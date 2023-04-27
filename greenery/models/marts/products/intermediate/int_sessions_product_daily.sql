
-- On average, how many unique sessions do we have per hour?
{{ 
    config(
        materialized='table'
    )
}}

with events as (
    select * 
    from {{ ref ('stg_postgres__events') }}
)
, events1 as (
   {{ session_event_count('event_type')}}

)

select {{ dbt_utils.generate_surrogate_key([
                'activity_date', 
                'product_id'
            ])
        }} as unique_key,
        * 
from final

