with transactions as (

    select * from {{ ref('stg_retail_transactions') }}

),

sales as (

    select
        invoice_id,
        stock_code,
        product_description,
        quantity,
        invoiced_at,
        unit_price,
        customer_id,
        country,
        quantity * unit_price as line_revenue

    from transactions
    where not is_cancellation
      and quantity > 0
      and unit_price > 0
      and stock_code not in ('POST', 'D', 'DOT', 'M', 'S', 'AMAZONFEE', 'CRUK', 'BANK CHARGES')

)

select * from sales