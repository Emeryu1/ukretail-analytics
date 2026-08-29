import duckdb
from pathlib import Path

Path("exports").mkdir(exist_ok=True)

con = duckdb.connect("retail.duckdb", read_only=True)

marts = ["fct_monthly_revenue", "fct_product_performance", "fct_customer_rfm"]

for mart in marts:
    con.execute(
        f"COPY (SELECT * FROM {mart}) TO 'exports/{mart}.parquet' (FORMAT PARQUET)"
    )
    print(f"Exported {mart}")

con.close()
print("Done. Files are in the exports folder.")