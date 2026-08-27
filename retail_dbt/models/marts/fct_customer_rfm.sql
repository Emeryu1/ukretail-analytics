with sales as (

    select * from {{ ref('int_sales') }}
    where customer_id is not null

),

customer_metrics as (

    select
        customer_id,
        max(invoiced_at)                     as last_purchase_at,
        count(distinct invoice_id)           as frequency,
        sum(line_revenue)                    as monetary

    from sales
    group by 1

),

scored as (

    select
        customer_id,
        last_purchase_at,
        frequency,
        monetary,
        ntile(5) over (order by last_purchase_at)  as recency_score,
        ntile(5) over (order by frequency)         as frequency_score,
        ntile(5) over (order by monetary)          as monetary_score

    from customer_metrics

),

segmented as (

    select
        *,
        case
            when recency_score >= 4 and frequency_score >= 4 then 'Champions'
            when recency_score >= 4 and frequency_score <= 2 then 'New / Promising'
            when recency_score <= 2 and frequency_score >= 4 then 'At Risk'
            when recency_score <= 2 and frequency_score <= 2 then 'Lost'
            else 'Regular'
        end as segment

    from scored

)

select * from segmented