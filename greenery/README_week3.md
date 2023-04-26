1. What is our overall conversion rate?
I made modifications to my intermediate table by adding session granularity and look at whether a session contains a specific type of event. Then I was able to use this table to calculate overall and product-level conversion rates.

Overall conversion rate is 62.4%

```
with t1 as (
select session_id,
boolor_agg(checkouts_events)::int as checkouts
from int_sessions_product_daily
group by 1
)
select sum(checkouts)/count(*) as conversion_rate_session
from t1 
```

for product level:
```
with t1 as (
select product_id
, session_id
, boolor_agg(checkouts_events)::int as checkouts
from int_sessions_product_daily
group by 1,2
)
select 
product_id
, sum(checkouts)/count(*) as conversion_rate_session
from t1 
group by 1
```
