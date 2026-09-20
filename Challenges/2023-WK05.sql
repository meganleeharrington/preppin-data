with t as (
    select to_char(to_date(split_part(transaction_date, ' ', 1), 'dd/mm/yyyy'), 'MMMM') as transaction_date
        ,split_part(transaction_code, '-', 1) as bank
        ,SUM(value) as value
    from pd2023_wk01
    group by 1,2
),

r as (
    select transaction_date
        ,bank
        ,value
        ,rank() over (partition by transaction_date order by value desc) as bank_rank_per_month
    from t
),

b as (
    select bank
    ,avg(bank_rank_per_month) as avg_rank_per_bank
    from r
    group by bank
),

tv as (
    select bank_rank_per_month
        ,avg(value) as avg_transaction_value_per_bank
    from r
    group by bank_rank_per_month
)

select r.transaction_date
    ,r.bank
    ,r.value
    ,r.bank_rank_per_month
    ,tv.avg_transaction_value_per_bank
    ,b.avg_rank_per_bank
from r
left join tv on r.bank_rank_per_month = tv.bank_rank_per_month
left join b on r.bank = b.bank;
