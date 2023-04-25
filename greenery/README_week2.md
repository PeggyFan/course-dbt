1. ##### What is our user repeat rate?
% of repeat users (who placed 2+ orders) is 79.84%

Query:
```
with t1 as (
select user_id, count(order_id) as orders
from fact_orders
group by 1
)

select avg(case when orders >= 2 then 1 else 0 end) as pct_repeat
from t1
```

2. ##### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
Repeated users on average experineced quicker delivery and use discounts 10x more than non-repeat users.

```
with t1 as (
select user_id, 
case when count(order_id) >= 2 then 1 else 0 end as repeated_user, 
avg(order_transit_days) as avg_transit,
avg(delivery_estimate_difference_hours) as avg_diff_hrs,
avg(order_total) as avg_total,
sum(case when order_discount is not null then 1 else 0 end) as discounts
from fact_orders
group by 1
)
select repeated_user, avg(avg_transit) as avg_transit,
avg(avg_diff_hrs) as avg_diff_hr,
avg(avg_total) as avg_total,
avg(discounts) as avg_discount
from t1
group by 1
```