with flat as (
select to_date(date, 'dd MMMM YYYY') as date
    ,time
    ,f.value::string as interesting_events
from pd2023_wk16_full_moon,
lateral flatten(
    input => regexp_substr_all(time,'\\[([^]]*)\\]',1,1,'e'),
    outer => true
) as f
),

dates as (
select to_date(easter_sunday, 'dd/MM/YYYY') as easter_sunday_new
    ,date
    ,case
        when interesting_events = '+' then 'Blue Moon'
        when interesting_events = '*' then 'Partial Lunar Eclipse'
        when interesting_events = '**' then 'Total Lunar Eclipse'
    end as interesting_events
    ,datediff('day', date, easter_sunday_new) as datediffs
    ,rank() over (partition by easter_sunday_new order by datediffs asc) as rnk
from pd2023_wk16_easters as e
cross join (select date, interesting_events from flat) as d
where easter_sunday_new > '1900-01-01' and datediffs >= 0
qualify rnk = 1
),

ie as (
select datediffs as days_between_full_moon_and_easter_sunday
    ,interesting_events as most_interesting_event
    ,case
        when interesting_events = 'Blue Moon' then 1
        when interesting_events = 'Partial Lunar Eclipse' then 2
        when interesting_events = 'Total Lunar Eclipse' then 3
        else 0
    end as points
    ,rank() over (partition by days_between_full_moon_and_easter_sunday order by points desc) as rk
from dates
group by 1,2
qualify rk = 1
order by days_between_full_moon_and_easter_sunday, points desc
)

select datediffs as days_between_full_moon_and_easter_sunday
    ,count(*) as number_of_occurances
    ,most_interesting_event
    ,min(year(date)) as min_year
    ,max(year(date)) as max_year
from dates as d
left join ie on d.datediffs = ie.days_between_full_moon_and_easter_sunday
group by 1,3
order by 1;
