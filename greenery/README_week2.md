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