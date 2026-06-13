# Mutual Fund Analytics Platform - Data Dictionary
Automatically generated from SQLite database schema.

# dim_fund
| Column Name | Data Type |
|------------|-----------|
| amfi_code | BIGINT |
| fund_house | TEXT |
| scheme_name | TEXT |
| category | TEXT |
| sub_category | TEXT |
| plan | TEXT |
| launch_date | TEXT |
| benchmark | TEXT |
| expense_ratio_pct | FLOAT |
| exit_load_pct | FLOAT |
| min_sip_amount | BIGINT |
| min_lumpsum_amount | BIGINT |
| fund_manager | TEXT |
| risk_category | TEXT |
| sebi_category_code | TEXT |

# dim_date
| Column Name | Data Type |
|------------|-----------|
| date_key | BIGINT |
| full_date | DATETIME |
| year | INTEGER |
| quarter | INTEGER |
| month | INTEGER |
| month_name | TEXT |
| day | INTEGER |

# fact_nav
| Column Name | Data Type |
|------------|-----------|
| amfi_code | BIGINT |
| date_key | BIGINT |
| nav | FLOAT |

# fact_transactions
| Column Name | Data Type |
|------------|-----------|
| investor_id | TEXT |
| transaction_date | DATETIME |
| amfi_code | BIGINT |
| transaction_type | TEXT |
| amount_inr | BIGINT |
| state | TEXT |
| city | TEXT |
| city_tier | TEXT |
| age_group | TEXT |
| gender | TEXT |
| annual_income_lakh | FLOAT |
| payment_mode | TEXT |
| kyc_status | TEXT |
| full_date | DATETIME |
| date_key | BIGINT |

# fact_performance
| Column Name | Data Type |
|------------|-----------|
| amfi_code | BIGINT |
| scheme_name | TEXT |
| cagr | FLOAT |
| sharpe | FLOAT |
| sortino | FLOAT |
| max_drawdown | FLOAT |
| last_nav | FLOAT |
| updated_at | DATETIME |

# fact_aum
| Column Name | Data Type |
|------------|-----------|
| date | DATETIME |
| fund_house | TEXT |
| aum_lakh_crore | FLOAT |
| aum_crore | BIGINT |
| num_schemes | BIGINT |
| full_date | DATETIME |
| date_key | BIGINT |
