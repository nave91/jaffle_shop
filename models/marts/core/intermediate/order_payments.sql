{% set payment_methods = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] %}

with payments as (

    select * from {{ ref('stg_payments') }}

), stripe_payments as (
    select * from {{ source ('stripe', 'payments')}}
),

final as (

    select
        order_id,

        {% for payment_method in payment_methods -%}
        sum(case when payment_method = '{{payment_method}}' then payments.amount else 0 end) as {{payment_method}}_amount,
        {% endfor -%}

        sum(payments.amount) as total_amount,
        sum(stripe_payments.amount) as stripe_amount

    from payments left join stripe_payments on payments.payment_id = stripe_payments.payment_id

    group by 1

)

select * from final
