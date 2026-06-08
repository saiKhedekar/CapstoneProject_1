t sqlite3
import pandas as pd

conn = sqlite3.connect("bluestock_mf.db")

query = """
SELECT name
FROM sqlite_master
WHERE type='table';
"""

print(pd.read_sql(query, conn))

conn.close()
