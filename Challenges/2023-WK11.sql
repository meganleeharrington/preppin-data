with t as (
select branch
    ,branch_lat
    ,branch_long
    ,branch_lat / (180 / pi()) as branch_lat_rad
    ,branch_long / (180 / pi()) as branch_long_rad
    ,address_lat / (180 / pi()) as address_lat_rad
    ,address_long / (180 / pi()) as address_long_rad
    ,round(3963 * acos((sin(branch_lat_rad) * sin(address_lat_rad)) + cos(branch_lat_rad) * cos(address_lat_rad) * cos(address_long_rad - branch_long_rad)),2) as distance
    ,address_lat
    ,address_long
    ,customer
from pd2023_wk11_dsb_customer_locations as cl
cross join pd2023_wk11_dsb_branches as b
qualify rank() over (partition by customer order by distance) = 1
)

select branch
    ,branch_long
    ,branch_lat
    ,distance
    ,rank() over (partition by branch order by distance) as customer_priority
    ,customer
    ,address_lat
    ,address_long
from t;
