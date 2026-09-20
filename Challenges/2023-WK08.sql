with t as (

select *
    ,'01/01/2023'::date as file_date
from pd2023_wk08_01

union all 

select *
    ,'02/01/2023'::date as file_date
from pd2023_wk08_02

union all 

select *
    ,'03/01/2023'::date as file_date
from pd2023_wk08_03

union all 

select *
    ,'04/01/2023'::date as file_date
from pd2023_wk08_04

union all 

select *
    ,'05/01/2023'::date as file_date
from pd2023_wk08_05

union all 

select *
    ,'06/01/2023'::date as file_date
from pd2023_wk08_06

union all 

select *
    ,'07/01/2023'::date as file_date
from pd2023_wk08_07

union all 

select *
    ,'08/01/2023'::date as file_date
from pd2023_wk08_08

union all 

select *
    ,'09/01/2023'::date as file_date
from pd2023_wk08_09

union all 

select *
    ,'10/01/2023'::date as file_date
from pd2023_wk08_10

union all 

select *
    ,'11/01/2023'::date as file_date
from pd2023_wk08_11

union all 

select *
    ,'12/01/2023'::date as file_date
from pd2023_wk08_12
),

b as (
select id 
    ,first_name
    ,last_name
    ,ticker
    ,sector
    ,market
    ,stock_name
    ,replace(replace(left(market_cap, length(market_cap) - 1), '$', ''), 'n/', 0)::float as market_captialization
    ,case 
        when right(market_cap, 1) = 'M' then 1000000 
        when right(market_cap, 1) = 'B' then 1000000000
        else 0 
    end as multiplier
    ,replace(purchase_price, '$', '')::float as purchase_price
    ,file_date
from t
)

select case
        when market_captialization * multiplier < 100000000 then 'Small'
        when market_captialization * multiplier < 1000000000 then 'Medium'
        when market_captialization * multiplier < 100000000000 then 'Large'
        else 'Huge'
    end as market_cap_category
    ,case
        when purchase_price < 25000 then 'Small'
        when purchase_price < 50000 then 'Medium'
        when purchase_price < 75000 then 'High'
        else 'Very High' 
    end as purchase_price_category
    ,file_date
    ,ticker
    ,sector 
    ,market
    ,stock_name
    ,market_captialization
    ,multiplier
    ,market_captialization * multiplier as market_captialization
    ,purchase_price
    ,rank() over (partition by file_date, purchase_price_category, market_cap_category order by purchase_price desc) as "Rank"
from b
qualify "Rank" <= 5
order by market_cap_category, purchase_price_category, file_date
;
