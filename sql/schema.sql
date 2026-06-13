-- ============================================================
-- Mutual Fund Analytics Platform
-- Star Schema Database Design
-- ============================================================

-- ============================================================
-- DIMENSION TABLES
-- ============================================================

DROP TABLE IF EXISTS dim_fund;

CREATE TABLE dim_fund (

    amfi_code BIGINT PRIMARY KEY,

    fund_house TEXT,
    scheme_name TEXT,

    category TEXT,
    sub_category TEXT,

    plan TEXT,

    launch_date TEXT,

    benchmark TEXT,

    expense_ratio_pct FLOAT,
    exit_load_pct FLOAT,

    min_sip_amount BIGINT,
    min_lumpsum_amount BIGINT,

    fund_manager TEXT,

    risk_category TEXT,

    sebi_category_code TEXT

);

-- ============================================================

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (

    date_key BIGINT PRIMARY KEY,

    full_date DATETIME,

    year INTEGER,
    quarter INTEGER,

    month INTEGER,
    month_name TEXT,

    day INTEGER

);

-- ============================================================
-- FACT TABLES
-- ============================================================

DROP TABLE IF EXISTS fact_nav;

CREATE TABLE fact_nav (

    amfi_code BIGINT,

    date_key BIGINT,

    nav FLOAT,

    PRIMARY KEY (
        amfi_code,
        date_key
    ),

    FOREIGN KEY (amfi_code)
        REFERENCES dim_fund(amfi_code),

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key)

);

-- ============================================================

DROP TABLE IF EXISTS fact_transactions;

CREATE TABLE fact_transactions (

    investor_id TEXT,

    transaction_date DATETIME,

    amfi_code BIGINT,

    transaction_type TEXT,

    amount_inr BIGINT,

    state TEXT,
    city TEXT,
    city_tier TEXT,

    age_group TEXT,
    gender TEXT,

    annual_income_lakh FLOAT,

    payment_mode TEXT,

    kyc_status TEXT,

    full_date DATETIME,

    date_key BIGINT,

    FOREIGN KEY (amfi_code)
        REFERENCES dim_fund(amfi_code),

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key)

);

-- ============================================================

DROP TABLE IF EXISTS fact_performance;

CREATE TABLE fact_performance (

    amfi_code BIGINT PRIMARY KEY,

    scheme_name TEXT,

    cagr FLOAT,

    sharpe FLOAT,

    sortino FLOAT,

    max_drawdown FLOAT,

    last_nav FLOAT,

    updated_at DATETIME

);
-- ============================================================

DROP TABLE IF EXISTS fact_aum;

CREATE TABLE fact_aum (

    date DATETIME,

    fund_house TEXT,

    aum_lakh_crore FLOAT,

    aum_crore BIGINT,

    num_schemes BIGINT,

    full_date DATETIME,

    date_key BIGINT,

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key)

);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_nav_amfi
ON fact_nav(amfi_code);

CREATE INDEX idx_nav_date
ON fact_nav(date_key);

CREATE INDEX idx_txn_amfi
ON fact_transactions(amfi_code);

CREATE INDEX idx_txn_date
ON fact_transactions(date_key);

CREATE INDEX idx_perf_amfi
ON fact_performance(amfi_code);

CREATE INDEX idx_aum_date
ON fact_aum(date_key);

CREATE INDEX idx_aum_fundhouse
ON fact_aum(fund_house);

-- ============================================================
-- END OF SCHEMA
-- ============================================================