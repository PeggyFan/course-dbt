
-- On average, how many unique sessions do we have per hour?
{{ 
    config(
        materialized='table'
    )
}}

{% set event_types = dbt_utils.get_column_values(
    table=ref('stg_postgres__events'), 
    column='event_type') 
%}

with user_product_sessions as (
    select 
        e.session_id
        , e.user_id
        , coalesce(e.product_id, op.product_id) as product_id
        , min(e.created_at)::date as activity_date
        , min(e.created_at) AS session_started_ts_utc
        , max(e.created_at) AS session_ended_ts_utc
        {% for event_type in event_types %}
        , {{ sum_of('e.event_type', event_type) }} as {{ event_type }}
        {% endfor %}
    from {{ ref ('stg_postgres__events') }} e
    left join {{ ref('int_user_order_products') }} op 
        on op.order_id = e.order_id
    group by 1, 2, 3
)

select {{ dbt_utils.generate_surrogate_key([
                'activity_date', 
                'product_id'
            ])
        }} as unique_key,
        * 
from user_product_sessions

