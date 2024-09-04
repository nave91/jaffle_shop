with sl as (
    select pg_sleep(10)
    )
select 1 from sl