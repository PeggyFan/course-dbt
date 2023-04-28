#### 1. What is our overall conversion rate?
I made modifications to my intermediate table by adding session granularity and look at whether a session contains a specific type of event. Then I was able to use this table to calculate overall and product-level conversion rates.

Overall conversion rate is 62.4%

<details>
<summary>Query</summary>
```
with t1 as (
select session_id,
boolor_agg(checkout)::int as checkouts
from int_sessions_product_daily
group by 1
)
select sum(checkouts)/count(*) as conversion_rate_session
from t1 
```
</details>

for product level:
| PRODUCT_ID                           | CONVERSION_RATE_SESSION |
|--------------------------------------|-------------------------|
| fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80 | 60.937500               |
| 74aeb414-e3dd-4e8a-beef-0fa45225214d | 55.555600               |
| 55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3 | 48.387100               |
| 579f4cd0-1f45-49d2-af55-9ab2b72c3b35 | 51.851900               |
| d3e228db-8ca5-42ad-bb0a-2148e876cc59 | 46.428600               |
| 615695d3-8ffd-4850-bcf7-944cf6d3685b | 49.230800               |
| 05df0866-1a66-41d8-9ed7-e2bbcddd6a3d | 45.000000               |
| e5ee99b6-519f-4218-8b41-62f48f59f700 | 40.909100               |
| 80eda933-749d-4fc6-91d5-613d29eb126f | 41.891900               |
| e8b6528e-a830-4d03-a027-473b411c7f02 | 39.726000               |
| e18f33a6-b89a-4fbc-82ad-ccba5bb261cc | 40.000000               |
| 5b50b820-1d0a-4231-9422-75e7f6b0cecf | 47.457600               |
| c17e63f7-0d28-4a95-8248-b01ea354840e | 54.545500               |
| 64d39754-03e4-4fa0-b1ea-5f4293315f67 | 47.457600               |
| 843b6553-dc6a-4fc4-bceb-02cd39af0168 | 42.647100               |
| b66a7143-c18a-43bb-b5dc-06bb5d1d3160 | 53.968300               |
| bb19d194-e1bd-4358-819e-cd1f1b401c0c | 42.307700               |
| b86ae24b-6f59-47e8-8adc-b17d88cbd367 | 50.943400               |
| e706ab70-b396-4d30-a6b2-a1ccf3625b52 | 50.000000               |
| 6f3a3072-a24d-4d11-9cef-25b0b5f8a4af | 41.176500               |
| 5ceddd13-cf00-481f-9285-8340ab95d06d | 49.253700               |
| be49171b-9f72-4fc9-bf7a-9a52e259836b | 51.020400               |
| 4cda01b9-62e2-46c5-830f-b7f262a58fb1 | 34.426200               |
| 37e0062f-bd15-4c3e-b272-558a86d90598 | 46.774200               |
| 35550082-a52d-4301-8f06-05b30f6f3616 | 48.888900               |
| c7050c3b-a898-424d-8d98-ab0aaad7bef4 | 45.333300               |
| 58b575f2-2192-4a53-9d21-df9a0c14fc25 | 39.344300               |
| e2e78dfc-f25c-4fec-a002-8e280d61a2f2 | 41.269800               |
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | 53.731300               |
| a88a23ef-679c-4743-b151-dc7722040d8c | 47.826100               |

<details>
<summary>Query</summary>
```
with t1 as (
select product_id
, session_id
, boolor_agg(checkout)::int as checkouts
from int_sessions_product_daily
group by 1,2
)
select 
product_id
, sum(checkouts)/count(*) as conversion_rate_session
from t1 
group by 1
```
</details>

#### Part 2-4 please refer to the repo under /macros and file dbt_project.yml

#### 6. Which products had their inventory change from week 2 to week 3? 
| change_date              | product_name     | CHANGED_FROM | CHANGED_TO |
|--------------------------|------------------|--------------|------------|
| 2023-04-24T23:25:12.069Z | Pothos           | 40           | 20         |
| 2023-04-24T23:25:12.069Z | Philodendron     | 51           | 25         |
| 2023-04-24T23:25:12.069Z | Monstera         | 77           | 64         |
| 2023-04-24T23:25:12.069Z | String of pearls | 58           | 10         |

<details>
<summary>Query</summary>
```
SELECT
	  s1.dbt_valid_to AS "change_date",
	  s1.name AS "product_name",
	  s1.inventory AS changed_from,
	  s2.inventory AS changed_to
	FROM products_snapshot s1
	JOIN products_snapshot s2 ON s1.product_id = s2.product_id 
    AND s1.dbt_valid_to = s2.dbt_valid_from
	WHERE s2.dbt_valid_to > DATEADD(day, -DATE_PART(dow, CURRENT_DATE()), CURRENT_DATE())
```
</details>