with orders as (
    select * from {{ ref('stg_orders') }}
),

order_metrics as (
    select
        order_id,
        customer_id,
        order_date,
        count(distinct product_id) as items_count,
        sum(quantity) as total_quantity,
        sum(amount) as order_amount,
        case 
            when status in ('paid', 'shipped') then true 
            else false 
        end as is_paid,
        case 
            when status = 'cancelled' then true 
            else false 
        end as is_cancelled
    from orders
    group by 
        order_id, 
        customer_id, 
        order_date, 
        status
)

select * from order_metrics
