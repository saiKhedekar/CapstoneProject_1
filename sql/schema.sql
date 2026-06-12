-- =====================================================
-- BLUESTOCK MUTUAL FUND STAR SCHEMA
-- Designed to match CSV structure exactly
-- =====================================================

PRAGMA foreign_keys = ON;

-- =====================================================
-- DIMENSION TABLE : FUND
-- Source:
-- clean_01_fund_master.csv
-- =====================================================

CREATE TABLE dim_fund (

```
amfi_code INTEGER PRIMARY KEY,

fund_house TEXT NOT NULL,

scheme_name TEXT NOT NULL,

category TEXT,

sub_category TEXT,

plan TEXT,

launch_date DATE,

benchmark TEXT,

expense_ratio_pct REAL,

exit_load_pct REAL,

min_sip_amount REAL,

min_lumpsum_amount REAL,

fund_manager TEXT,

risk_category TEXT,

sebi_category_code TEXT
```

);

-- =====================================================
-- DIMENSION TABLE : DATE
-- Generated from all unique dates
-- =====================================================

CREATE TABLE dim_date (

```
date_key INTEGER PRIMARY KEY,

full_date DATE UNIQUE,

year INTEGER,

quarter INTEGER,

month INTEGER,

month_name TEXT,

day INTEGER
```

);

-- =====================================================
-- FACT TABLE : NAV HISTORY
-- Source:
-- clean_02_nav_history.csv
-- =====================================================

CREATE TABLE fact_nav (

```
nav_id INTEGER PRIMARY KEY AUTOINCREMENT,

amfi_code INTEGER NOT NULL,

date_key INTEGER NOT NULL,

nav REAL NOT NULL,

FOREIGN KEY (amfi_code)
    REFERENCES dim_fund(amfi_code),

FOREIGN KEY (date_key)
    REFERENCES dim_date(date_key)
```

);

-- =====================================================
-- FACT TABLE : INVESTOR TRANSACTIONS
-- Source:
-- clean_08_investor_transactions.csv
-- =====================================================

CREATE TABLE fact_transactions (

```
transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,

investor_id INTEGER,

amfi_code INTEGER NOT NULL,

date_key INTEGER NOT NULL,

transaction_type TEXT,

amount_inr REAL,

state TEXT,

city TEXT,

city_tier TEXT,

age_group TEXT,

gender TEXT,

annual_income_lakh REAL,

payment_mode TEXT,

kyc_status TEXT,

FOREIGN KEY (amfi_code)
    REFERENCES dim_fund(amfi_code),

FOREIGN KEY (date_key)
    REFERENCES dim_date(date_key)
```

);

-- =====================================================
-- FACT TABLE : PERFORMANCE
-- Source:
-- clean_07_scheme_performance.csv
-- =====================================================

CREATE TABLE fact_performance (

```
performance_id INTEGER PRIMARY KEY AUTOINCREMENT,

amfi_code INTEGER NOT NULL,

return_1yr_pct REAL,

return_3yr_pct REAL,

return_5yr_pct REAL,

benchmark_3yr_pct REAL,

alpha REAL,

beta REAL,

sharpe_ratio REAL,

sortino_ratio REAL,

std_dev_ann_pct REAL,

max_drawdown_pct REAL,

aum_crore REAL,

expense_ratio_pct REAL,

morningstar_rating INTEGER,

risk_grade TEXT,

expense_ratio_flag TEXT,

FOREIGN KEY (amfi_code)
    REFERENCES dim_fund(amfi_code)
```

);

-- =====================================================
-- FACT TABLE : AUM
-- Source:
-- clean_03_aum_by_fund_house.csv
-- =====================================================

CREATE TABLE fact_aum (

```
aum_id INTEGER PRIMARY KEY AUTOINCREMENT,

date_key INTEGER NOT NULL,

fund_house TEXT NOT NULL,

aum_lakh_crore REAL,

aum_crore REAL,

num_schemes INTEGER,

FOREIGN KEY (date_key)
    REFERENCES dim_date(date_key)
```

);

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX idx_nav_amfi
ON fact_nav(amfi_code);

CREATE INDEX idx_nav_date
ON fact_nav(date_key);

CREATE INDEX idx_tx_amfi
ON fact_transactions(amfi_code);

CREATE INDEX idx_tx_date
ON fact_transactions(date_key);

CREATE INDEX idx_perf_amfi
ON fact_performance(amfi_code);

CREATE INDEX idx_aum_date
ON fact_aum(date_key);
