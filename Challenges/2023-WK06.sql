with t as (

select customer_id
    ,'ease of use' as criteria
    ,mobile_app___ease_of_use as mobile_app
    ,online_interface___ease_of_use as online_interface
from pd2023_wk06_dsb_customer_survey

union all

select customer_id
    ,'ease of access' as criteria
    ,mobile_app___ease_of_access as mobile_app
    ,online_interface___ease_of_access as online_interface
from pd2023_wk06_dsb_customer_survey

union all

select customer_id
    ,'navigation' as criteria
    ,mobile_app___navigation as mobile_app
    ,online_interface___navigation as online_interface
from pd2023_wk06_dsb_customer_survey

union all

select customer_id
    ,'likelihood to recommend' as criteria
    ,mobile_app___likelihood_to_recommend as mobile_app
    ,online_interface___likelihood_to_recommend as online_interface
from pd2023_wk06_dsb_customer_survey
),

a as (
select customer_id
    ,avg(mobile_app) as mobile_rating
    ,avg(online_interface) as online_rating
    ,avg(mobile_app) - avg(online_interface) as mobile_min_online
from t
group by all
),

b as (
select count(distinct customer_id) as total
from t
)

select (case
        when mobile_min_online >= 2 then 'Mobile App Superfan'
        when mobile_min_online >= 1 then 'Mobile App Fan'
        when mobile_min_online > -1 then 'Neutral'
        when mobile_min_online > -2 then 'Online Interface Fan'
        else 'Online Interface Superfan'
        end) as preference
    ,round(count(*) / sum(count(*)) over () * 100,1) as percent_of_total
from a
cross join b
group by all;
