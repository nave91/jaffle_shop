with source as (
    select * from "dbttest1"."public"."raw_orders"

),

renamed as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from source

    union all

    select
	id as order_id,
	null as customer_id,
	null as order_date,
	null as status
    from
	"dbttest1"."public"."source1"

)

select * from renamed