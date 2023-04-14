#### 1. How many users do we have?
130

```
select
    count(*)
from
    dev_db.DBT_PEGGYPRODUCTHUNTCO.STG_POSTGRES__USERS
```
#### 2. On average, how many orders do we receive per hour?
7.5

```
with base as (
select
    date_trunc('hour', created_at) as hour, 
    count(*) as orders
from
    dev_db.DBT_PEGGYPRODUCTHUNTCO.STG_POSTGRES__ORDERS
group by 1
)
select avg(orders)
from base 

```
#### 3. On average, how long does an order take from being placed to being delivered?
3.89 days
```
with base as (
select
    datediff(day, created_at, delivered_at) as duration_min
from
    dev_db.DBT_PEGGYPRODUCTHUNTCO.STG_POSTGRES__ORDERS
)
select avg(duration_min)
from base
```

#### 4. How many users have only made one purchase? Two purchases? Three+ purchases?
1 purchase -> 25
2 purhcases -> 28
3 purchases -> 75

```
with base as (
select
    user_id, count(*) as num_orders
from
    dev_db.DBT_PEGGYPRODUCTHUNTCO.STG_POSTGRES__ORDERS
group by 1
)
select 
case when num_orders = 1 then 'one'
when num_orders = 2 then 'two'
when num_orders >= 3 then 'three+' end as num_orders, 
count(distinct user_id) as users
from base 
group by 1
```


#### 5. On average, how many unique sessions do we have per hour?
16.33

```
with base as (
select
    user_id, count(*) as num_orders
from
    dev_db.DBT_PEGGYPRODUCTHUNTCO.STG_POSTGRES__ORDERS
group by 1
)
select 
case when num_orders = 1 then 'one'
when num_orders = 2 then 'two'
when num_orders >= 3 then 'three+' end as num_orders, 
count(distinct user_id) as users
from base 
group by 1
```
