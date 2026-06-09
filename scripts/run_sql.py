#Script to make the schema
DB_PATH = r"C:\Users\Sai Khedekar\Desktop\CapstoneProject_1\data\db\bluestock_mf.db"

# import sqlite3
# conn = sqlite3.connect(DB_PATH)
# # Run schema.sql
# with open("sql/schema.sql", "r") as f:
#     conn.executescript(f.read())

# print("Schema created successfullyz!")

# conn.commit()
# conn.close()


#script to verify if tables are made or not
# import sqlite3
# import pandas as pd

# conn = sqlite3.connect(DB_PATH)

# query = """
# SELECT name
# FROM sqlite_master
# WHERE type='table';
# """

# print(pd.read_sql(query, conn))

# conn.close()

# Runing queries.sql on our ddatabase
import sqlite3
import pandas as pd

conn = sqlite3.connect(DB_PATH)

query = """
SELECT
    fund_house,
    SUM(aum_crore) AS total_aum
FROM fact_aum
GROUP BY fund_house
ORDER BY total_aum DESC
LIMIT 5;
"""

result = pd.read_sql(query, conn)

print(result)

conn.close()
