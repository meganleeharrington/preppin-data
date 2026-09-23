with tr as (
select (case when online_or_in_person = 1 then 'online' else 'in-person' end) as online_or_in_person
    ,QUARTER(TO_TIMESTAMP(transaction_date, 'DD/MM/YYYY HH24:MI:SS')) as quarter_number
    ,SUM(value) as value
from pd2023_wk01
where SPLIT_PART(transaction_code, '-', 1) = 'DSB'
group by 1,2
),

ta as (
select online_or_in_person
    ,Q1 as targets
    ,1 as quarter_number
from pd2023_wk03_targets

UNION ALL

select online_or_in_person
    ,Q2 as targets
    ,2 as quarter_number
from pd2023_wk03_targets

UNION ALL

select online_or_in_person
    ,Q3 as targets
    ,3 as quarter_number
from pd2023_wk03_targets

UNION ALL

select online_or_in_person
    ,Q4 as targets
    ,4 as quarter_number
from pd2023_wk03_targets
)

select tr.online_or_in_person
    ,tr.quarter_number
    ,tr.value
    ,ta.targets as quarterly_targets
    ,value - quarterly_targets as variance_to_target
from tr
left join ta
on tr.quarter_number = ta.quarter_number and lower(tr.online_or_in_person) = lower(ta.online_or_in_person);
