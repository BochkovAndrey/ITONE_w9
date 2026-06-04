with order_metrics as (
    select * from {{ ref('int_order_metrics') }}
),

daily_aggregates as (
    select
        order_date as sale_date,
        count(distinct order_id) as orders_count,
        count(distinct case when is_paid then order_id end) as paid_orders_count,
        count(distinct case when is_cancelled then order_id end) as cancelled_count,
        count(distinct customer_id) as unique_customers,
        sum(case when is_paid then order_amount else 0 end) as total_revenue,
        avg(case when is_paid then order_amount end) as avg_order_value
    from order_metrics
    group by order_date
)

select
    *,
    round(cancelled_count::numeric / nullif(orders_count, 0) * 100, 2) as cancellation_rate
from daily_aggregates
order by sale_date