with t as (
select x_2
    ,x_4 as row_identifier
    ,x_3 as row_identifier_2
    ,x_3::string as x_3
    ,x_4::string as x_4
    ,x_5::string as x_5
    ,x_6::string as x_6
    ,x_7::string as x_7
    ,x_8::string as x_8
    ,x_9::string as x_9
    ,x_10::string as x_10
    ,x_11::string as x_11
    ,x_12::string as x_12
    ,x_13::string as x_13
    ,x_14::string as x_14
    ,x_15::string as x_15
    ,x_16::string as x_16
    ,x_17::string as x_17
    ,x_18::string as x_18
    ,x_19::string as x_19
    ,x_20::string as x_20
    ,x_21::string as x_21
    ,x_22::string as x_22
    ,x_23::string as x_23
    ,x_24::string as x_24
    ,x_25::string as x_25
    ,x_26::string as x_26
    ,x_27::string as x_27
    ,x_28::string as x_28
    ,x_29::string as x_29
    ,x_30::string as x_30
    ,x_31::string as x_31
    ,x_32::string as x_32
    ,x_33::string as x_33
    ,x_34::string as x_34
    ,x_35::string as x_35
    ,x_36::string as x_36
    ,x_37::string as x_37
from PD2023_WK15_EASTER_DATES
),

years as (
select original_column
    ,year_value
from t
unpivot (year_value for original_column IN (
    x_3
    ,x_4
    ,x_5
    ,x_6
    ,x_7
    ,x_8
    ,x_9
    ,x_10
    ,x_11
    ,x_12
    ,x_13
    ,x_14
    ,x_15
    ,x_16
    ,x_17
    ,x_18
    ,x_19
    ,x_20
    ,x_21
    ,x_22
    ,x_23
    ,x_24
    ,x_25
    ,x_26
    ,x_27
    ,x_28
    ,x_29
    ,x_30
    ,x_31
    ,x_32
    ,x_33
    ,x_34
    ,x_35
    ,x_36
    ,x_37
))
where x_2 IS NOT NULL
),

months as (
select original_column
    ,month_value
from t
unpivot(month_value for original_column IN (
    x_3
    ,x_4
    ,x_5
    ,x_6
    ,x_7
    ,x_8
    ,x_9
    ,x_10
    ,x_11
    ,x_12
    ,x_13
    ,x_14
    ,x_15
    ,x_16
    ,x_17
    ,x_18
    ,x_19
    ,x_20
    ,x_21
    ,x_22
    ,x_23
    ,x_24
    ,x_25
    ,x_26
    ,x_27
    ,x_28
    ,x_29
    ,x_30
    ,x_31
    ,x_32
    ,x_33
    ,x_34
    ,x_35
    ,x_36
    ,x_37
))
where row_identifier_2 = 'M a r c h'
),

days as (
select original_column
    ,day_value
from t
unpivot (day_value for original_column IN (
    x_3
    ,x_4
    ,x_5
    ,x_6
    ,x_7
    ,x_8
    ,x_9
    ,x_10
    ,x_11
    ,x_12
    ,x_13
    ,x_14
    ,x_15
    ,x_16
    ,x_17
    ,x_18
    ,x_19
    ,x_20
    ,x_21
    ,x_22
    ,x_23
    ,x_24
    ,x_25
    ,x_26
    ,x_27
    ,x_28
    ,x_29
    ,x_30
    ,x_31
    ,x_32
    ,x_33
    ,x_34
    ,x_35
    ,x_36
    ,x_37
))
where x_2 IS NULL and row_identifier IS NOT NULL
),

datepart as (
select replace(y.original_column, 'X_', '')::int as column_number
    ,year_value
    ,day_value
    ,last_value(case 
        when month_value = 'M a r c h' then '03'
        when month_value = 'A p r i l' then '04'
    end) ignore nulls over (order by column_number rows between unbounded preceding and current row) as month_value
from years as y
left join days as d on y.original_column = d.original_column
left join months as m on y.original_column = m.original_column
where year_value != ''
order by column_number asc)

select concat(year_value, '-', month_value, '-', day_value)::date as Easter_Sunday
from datepart;
