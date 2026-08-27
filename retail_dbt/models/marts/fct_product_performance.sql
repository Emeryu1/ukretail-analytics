with sales as (

    select * from {{ ref('int_sales') }}

),

products as (

    select
        stock_code,
        max(product_description)             as product_description,
        count(distinct invoice_id)           as order_count,
        sum(quantity)                        as units_sold,
        sum(line_revenue)                    as total_revenue,
        avg(unit_price)                      as avg_unit_price

    from sales
    group by 1

)

select * from products