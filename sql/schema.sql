-- =====================================================
-- BLUESTOCK MUTUAL FUND DATA WAREHOUSE
-- =====================================================

PRAGMA foreign_keys = ON;

-- =====================================================
-- DIMENSION TABLES
-- =====================================================

CREATE TABLE IF NOT EXISTS dim_fund (
    amfi_code INTEGER PRIMARY KEY,
    scheme_name TEXT NOT NULL,
    fund_house TEXT,
    category TEXT,
    sub_category TEXT,
    expense_ratio REAL,
    risk_grade TEXT,
    fund_manager TEXT
);



CREATE TABLE IF NOT EXISTS dim_date (
    date_id INTEGER PRIMARY KEY,
    full_date DATE UNIQUE,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    month_name TEXT,
    day INTEGER,
    weekday INTEGER,
    is_weekday INTEGER
);

-- =====================================================
-- FACT NAV
-- =====================================================

CREATE TABLE IF NOT EXISTS fact_nav (
    nav_id INTEGER PRIMARY KEY AUTOINCREMENT,
    amfi_code INTEGER,
    date_id INTEGER,
    nav REAL,
    daily_return_pct REAL,

    FOREIGN KEY(amfi_code)
        REFERENCES dim_fund(amfi_code),

    FOREIGN KEY(date_id)
        REFERENCES dim_date(date_id)
);

-- =====================================================
-- FACT TRANSACTIONS
-- =====================================================

CREATE TABLE IF NOT EXISTS fact_transactions (
    tx_id INTEGER PRIMARY KEY,
    investor_id INTEGER,
    amfi_code INTEGER,
    date_id INTEGER,
    state TEXT,
    city_tier TEXT,
    age_group TEXT,
    amount REAL,
    transaction_type TEXT,
    kyc_status TEXT,

    FOREIGN KEY(amfi_code)
        REFERENCES dim_fund(amfi_code),

    FOREIGN KEY(date_id)
        REFERENCES dim_date(date_id)
);

-- =====================================================
-- FACT PERFORMANCE
-- =====================================================

CREATE TABLE IF NOT EXISTS fact_performance (
    performance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    amfi_code INTEGER,
    as_of_date DATE,
    return_1yr REAL,
    return_3yr REAL,
    return_5yr REAL,
    sharpe REAL,
    sortino REAL,
    alpha REAL,
    beta REAL,
    max_drawdown REAL,
    std_dev REAL,

    FOREIGN KEY(amfi_code)
        REFERENCES dim_fund(amfi_code)
);

-- =====================================================
-- FACT AUM
-- =====================================================

CREATE TABLE IF NOT EXISTS fact_aum (
    aum_id INTEGER PRIMARY KEY AUTOINCREMENT,
    fund_house TEXT,
    date_id INTEGER,
    aum_crore REAL,
    num_schemes INTEGER,

    FOREIGN KEY(date_id)
        REFERENCES dim_date(date_id)
);

-- =====================================================
-- FACT PORTFOLIO
-- =====================================================

CREATE TABLE IF NOT EXISTS fact_portfolio (
    holding_id INTEGER PRIMARY KEY AUTOINCREMENT,
    amfi_code INTEGER,
    stock_symbol TEXT,
    stock_name TEXT,
    sector TEXT,
    weight_pct REAL,
    portfolio_date DATE,

    FOREIGN KEY(amfi_code)
        REFERENCES dim_fund(amfi_code)
);

-- =====================================================
-- FACT SIP INDUSTRY
-- =====================================================

CREATE TABLE IF NOT EXISTS fact_sip_industry (

    sip_id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_id INTEGER,
    sip_inflow_crore REAL,
    active_sip_accounts REAL,
    new_registrations REAL,
    sip_aum_crore REAL,

    FOREIGN KEY(date_id)
        REFERENCES dim_date(date_id)
);

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX idx_nav_amfi
ON fact_nav(amfi_code);

CREATE INDEX idx_nav_date
ON fact_nav(date_id);

CREATE INDEX idx_tx_amfi
ON fact_transactions(amfi_code);

CREATE INDEX idx_tx_date
ON fact_transactions(date_id);

CREATE INDEX idx_perf_amfi
ON fact_performance(amfi_code);