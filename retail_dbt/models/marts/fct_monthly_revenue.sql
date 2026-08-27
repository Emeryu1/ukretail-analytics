with sales as (

    select * from {{ ref('int_sales') }}

),

monthly as (

    select
        date_trunc('month', invoiced_at)     as revenue_month,
        country,
        count(distinct invoice_id)           as order_count,
        count(distinct customer_id)          as customer_count,
        sum(quantity)                        as units_sold,
        sum(line_revenue)                    as total_revenue

    from sales
    group by 1, 2

)

select * from monthly