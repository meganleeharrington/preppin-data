with recursive t as (select td.transaction_id
    ,transaction_date
    ,value
    ,cancelled_
    ,account_to
    ,account_from
from pd2023_wk07_transaction_detail as td
left join pd2023_wk07_transaction_path as tp
on td.transaction_id = tp.transaction_id
where cancelled_ = 'N'
),

u as (
select account_to as account_number
    ,transaction_date
    ,value as transaction_value
    ,NULL as balance
from t

union all

select account_from as account_number
    ,transaction_date
    ,value * -1 as transaction_value
    ,NULL as balance
from t

union all

select account_number
    ,balance_date as transaction_date
    ,balance as transaction_value
    ,balance
from pd2023_wk07_account_information
),

o as (
select account_number
    ,transaction_date
    ,case
        when transaction_value = balance then NULL
        else transaction_value
    end as transaction_value
    ,sum(transaction_value) over (partition by account_number order by transaction_date, transaction_value desc) as new_balance
    ,rank() over (partition by account_number, transaction_date order by transaction_value asc) as transaction_order_flag
from u
order by 1,2,5
),


--beginning of the new query
a as (
select account_number
    ,transaction_date
    ,sum(transaction_value) as transaction_value
from o
group by all
),

b as (
select a.account_number
    ,a.transaction_date
    ,transaction_value
    ,sub.new_balance
from a
left join (select account_number
        ,transaction_date
        ,new_balance
    from o
    where transaction_order_flag = 1) as sub
on a.account_number = sub.account_number and a.transaction_date = sub.transaction_date
order by 2
),

dates (date_value) as (
    select date '2023-01-31'
    union all
    select dateadd(day, 1, date_value)
    from dates
     WHERE date_value < DATE '2023-02-14'
),

cj as (
select date_value
    ,account_number
from dates as d
cross join (select distinct account_number
    from b) as accounts
),

j as (
    select cj.date_value
        ,cj.account_number
        ,transaction_value
        ,new_balance as balance
    from cj
    left join b
    on b.transaction_date = cj.date_value and cj.account_number = b.account_number
),

semifinal as (
    select date_value
        ,last_value(account_number) ignore nulls over (order by account_number, date_value rows between unbounded preceding and current row) as account_number
        ,last_value(balance) ignore nulls over (order by account_number, date_value rows between unbounded preceding and current row) as balance
        ,transaction_value
    from j
)

select *
from semifinal
where date_value = '2023-02-01'
order by account_number;
