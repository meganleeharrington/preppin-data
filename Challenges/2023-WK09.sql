with t as (select td.transaction_id
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
from pd2023_wk07_account_information)

select account_number
    ,transaction_date
    ,case
        when transaction_value = balance then NULL
        else transaction_value
    end as transaction_value
    ,sum(transaction_value) over (partition by account_number order by transaction_date, transaction_value desc) as new_balance
from u
order by 1,2,3;
