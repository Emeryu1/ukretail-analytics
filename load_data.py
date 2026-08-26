import duckdb
import pandas as pd

print("Reading Excel file, this takes a minute or two...")
sheets = pd.read_excel(
    "data/online_retail_II.xlsx",
    sheet_name=["Year 2009-2010", "Year 2010-2011"]
)
df = pd.concat(sheets.values(), ignore_index=True)
print(f"Loaded {len(df):,} rows")

con = duckdb.connect("retail.duckdb")
con.execute("CREATE SCHEMA IF NOT EXISTS raw")
con.execute("CREATE OR REPLACE TABLE raw.online_retail AS SELECT * FROM df")

count = con.execute("SELECT COUNT(*) FROM raw.online_retail").fetchone()[0]
print(f"Database now contains {count:,} rows in raw.online_retail")
con.close()