{% snapshot promos_snapshot %}

{{ 
    config(
        target_database=target.database,
        target_schema=target.schema,

        strategy='check',
        unique_key='promo_id',
        check_cols=['status'],
    )
}}

select * 
from {{source('postgres', 'promos')}}

{% endsnapshot %}