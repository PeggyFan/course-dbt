##### Part 1. 

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
	WHERE s2.dbt_valid_to is null
    and s2.dbt_valid_from >= '2023-04-24'
```
</details>

| change_date | product_name | CHANGED_FROM | CHANGED_TO |
| --- | --- | --- | --- |
| 2023-04-28T17:07:44.54Z | Philodendron | 25  | 15  |
| 2023-04-28T17:07:44.54Z | Bamboo | 56  | 44  |
| 2023-04-28T17:07:44.54Z | Pothos | 20  | 0   |
| 2023-04-28T17:07:44.54Z | String of pearls | 10  | 0   |
| 2023-04-28T17:07:44.54Z | ZZ Plant | 89  | 53  |
| 2023-04-28T17:07:44.54Z | Monstera | 64  | 50  |

Pothos and String of Pearls sold out at the end of week 3.
Looking at the changes in inventory in the last three weeks, products that appear more than once has higher volatility: `String of pearls`, `Pothos`, `Philodendron`, and `Monstera`

| change_date | product_name | CHANGED_FROM | CHANGED_TO | DIFFERENCE |
| --- | --- | --- | --- | --- |
| 2023-04-28T17:07:44.54Z | Bamboo | 56  | 44  | 12  |
| 2023-04-28T17:07:44.54Z | Monstera | 64  | 50  | 14  |
| 2023-04-24T23:25:12.069Z | Monstera | 77  | 64  | 13  |
| 2023-04-28T17:07:44.54Z | Philodendron | 25  | 15  | 10  |
| 2023-04-24T23:25:12.069Z | Philodendron | 51  | 25  | 26  |
| 2023-04-28T17:07:44.54Z | Pothos | 20  | 0   | 20  |
| 2023-04-24T23:25:12.069Z | Pothos | 40  | 20  | 20  |
| 2023-04-28T17:07:44.54Z | String of pearls | 10  | 0   | 10  |
| 2023-04-24T23:25:12.069Z | String of pearls | 58  | 10  | 48  |
| 2023-04-28T17:07:44.54Z | ZZ Plant | 89  | 53  | 36  |


##### Part 2. 
[My Sigma workbook link](https://app.sigmacomputing.com/corise-dbt/workbook/Greenery-Key-Metrics-Peggy-1znWjIcpugYjIjWzTx6x9a?:nodeId=NtleSMgmoH)

##### Part 3A.
We used dbt at the very basic level, so this course has given me a lot to think about in terms of data modeling
and the macros/jinjas that opened door to writing more streamlined queries.
The yaml files allow for many configurations that could help orchestrate jobs

##### Part 3B.
I will probably use airflow or dbt Cloud (if budget permits).
I will schedule a hourly run of the tables to make sure everything is working as expected (traffic, number of orders placed, etc).

Metadata I would be interested in
* run time
* configuration settings
* error messages
* table and schema used
The metadata will help me troubleshoot any bottleneck in the models and failures so we can address issues promptly.