--SETUP
with t as (select TRANSACTION_CODE
    ,REGEXP_SUBSTR(transaction_code, '^[A-Z]{2,3}') as BANK
    ,VALUE
    ,customer_code
    ,(case when online_or_in_person = 1 then 'online'
    when online_or_in_person = 2 then 'in-person'
    end) as online_or_in_person
    ,DAYNAME(TO_TIMESTAMP(transaction_date, 'DD/MM/YYYY HH24:MI:SS')) AS day_name
    ,transaction_date
from pd2023_wk01)

--OUTPUT 1
select bank
    ,sum(value)
from t
group by bank;

--OUTPUT 2
select BANK
    ,online_or_in_person
    ,day_name
    ,SUM(VALUE) as value
from t
group by 1,2,3
order by bank, value;

--OUTPUT 3
select BANK
    ,customer_code
    ,sum(value)
from t
group by 1,2
order by 1,2;
