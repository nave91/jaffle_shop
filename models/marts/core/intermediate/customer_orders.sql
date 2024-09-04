with orders as (

    select * from {{ ref('stg_orders') }}

),

final as (

    select
        customer_id,

        min(order_date) as first_order,
        max(order_date) as most_recent_order,
        count(order_id) as number_of_orders
    from orders
    where order_date >= '{{ var('start_date')}}'

    group by 1

),

delay_ as (
    select
        null as customer_id,
        null as first_order,
        null as most_recent_order,
        null as number_of_orders,
        pg_sleep(3000) as nothing
)

select
    customer_id,
    first_order,
    most_recent_order,
    number_of_orders
from final
union
select
    cast(customer_id as int) as customer_id,
    cast(first_order as date) as first_order,
    cast(most_recent_order as date) as most_recent_order,
    cast(number_of_orders as int) as number_of_orders
from
    delay_
