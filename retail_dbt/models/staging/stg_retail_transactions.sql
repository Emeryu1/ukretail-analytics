with source as (

    select * from {{ source('raw', 'online_retail') }}

),

renamed as (

    select
        Invoice                       as invoice_id,
        StockCode                     as stock_code,
        Description                   as product_description,
        Quantity                      as quantity,
        InvoiceDate                   as invoiced_at,
        Price                         as unit_price,
        "Customer ID"                 as customer_id,
        Country                       as country,
        Invoice like 'C%'             as is_cancellation

    from source

)

select * from renamed