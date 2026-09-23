with t as (

select *
    ,1 as month
from pd2023_wk08_01

union all 

select *
    ,2 as month
from pd2023_wk08_02

union all 

select *
    ,3 as month
from pd2023_wk08_03

union all 

select *
    ,4 as month
from pd2023_wk08_04

union all 

select *
    ,5 as month
from pd2023_wk08_05

union all 

select *
    ,6 as month
from pd2023_wk08_06

union all 

select *
    ,7 as month
from pd2023_wk08_07

union all 

select *
    ,8 as month
from pd2023_wk08_08

union all 

select *
    ,9 as month
from pd2023_wk08_09

union all 

select *
    ,10 as month
from pd2023_wk08_10

union all 

select *
    ,11 as month
from pd2023_wk08_11

union all 

select *
    ,12 as month
from pd2023_wk08_12
),

a as (
select rank() over (partition by sector order by month, id asc) as trade_order
    ,sector
    ,replace(purchase_price, '$', '')::float as purchase_price
from t
),

b as 
(
select trade_order
    ,sector
    ,round(avg(purchase_price) over (partition by sector order by trade_order rows between 2 preceding and current row), 2) as rolling_avg_purchase_price
    ,rank() over (partition by sector order by trade_order desc) as last_trades
from a
qualify rank() over (partition by sector order by trade_order desc) <= 100
)

select rank() over (partition by sector order by trade_order asc) as previous_trades
    ,trade_order
    ,sector
    ,rolling_avg_purchase_price
from b
;
