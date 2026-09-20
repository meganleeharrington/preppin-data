with tb as (select *, 1 as month_num from pd2023_wk04_january
UNION ALL
select *, 2 as month_num from pd2023_wk04_february
UNION ALL
select *, 3 as month_num from pd2023_wk04_march
UNION ALL
select *, 4 as month_num from pd2023_wk04_april
UNION ALL
select *, 5 as month_num from pd2023_wk04_may
UNION ALL
select *, 6 as month_num from pd2023_wk04_june
UNION ALL
select *, 7 as month_num from pd2023_wk04_july
UNION ALL
select id
    ,joining_day
    ,demographiic as demographic
    ,value
    , 8 as month_num
from pd2023_wk04_august
UNION ALL
select *, 9 as month_num from pd2023_wk04_september
UNION ALL
select id
    ,joining_day
    ,demagraphic as demographic
    ,value
    , 10 as month_num
from pd2023_wk04_october
UNION ALL
select *, 11 as month_num from pd2023_wk04_november
UNION ALL
select *, 12 as month_num from pd2023_wk04_december),

e as (select id
    ,date_from_parts(2023,month_num, joining_day) as joining_date
    ,value as ethnicity
from tb
where demographic = 'Ethnicity'),

a as (select id
    ,date_from_parts(2023,month_num, joining_day) as joining_date
    ,value as account_type
from tb
where demographic = 'Account Type'),

dob as (select id
    ,date_from_parts(2023,month_num, joining_day) as joining_date
    ,value as date_of_birth
from tb
where demographic = 'Date of Birth')

select e.id
    ,e.joining_date
    ,ethnicity
    ,account_type
    ,date_of_birth
from e
left join a
on e.id = a.id and e.joining_date = a.joining_date
left join dob
on e.id = dob.id and e.joining_date = dob.joining_date;
