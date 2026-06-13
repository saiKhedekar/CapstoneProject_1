# Mutual Fund Analytics Platform

A complete mutual fund analytics solution built with Python, Jupyter, SQLite, and Power BI.

This repository combines raw mutual fund datasets, a reproducible ETL pipeline, analytical notebooks, performance and portfolio reports, live NAV ingestion, and an interactive Power BI dashboard.

---

## Project Overview

The platform is designed to help mutual fund investors, analysts, and fund managers gain clear insights into:

- fund performance and risk metrics
- SIP inflows and investor behavior
- fund house AUM dynamics
- benchmark comparisons and portfolio exposures
- data quality, cleaning, and analytics-ready dataset creation

The repository contains the full analytics lifecycle from raw CSV ingestion to cleaned dataset outputs, SQL warehouse modeling, and executive dashboard deliverables.

---

## Key Deliverables

- `data/raw/`: original source datasets for funds, NAV history, AUM, SIP, transactions, holdings, and benchmarks
- `data/processed/`: cleaned, analytics-ready CSV files
- `data/db/bluestock_mf.db`: SQLite warehouse database for analytics
- `sql/schema.sql`: star schema definition for fact and dimension tables
- `notebooks/`: end-to-end notebooks for ingestion, cleaning, EDA, performance, portfolio analytics, and simulations
- `scripts/01_live_fetch_nav.py`: live NAV fetcher and NAV history updater
- `scripts/02_etl_pipeline.py`: ETL pipeline runner
- `scripts/03_weekly_report.py`: HTML weekly report generator
- `scripts/recommender.py`: risk-based fund recommender based on Sharpe ratio
- `dashboard/`: Power BI dashboard file, PDF, and screenshots

---

## Repository Structure

```
CapstoneProject_1/
├── dashboard/
│   ├── Bluestocks_mf.pbix
│   ├── Bluestocks_mf.pdf
│   └── Dashboard Screenshots/
├── data/
│   ├── db/
│   │   ├── Bluestocks_mf.db
│   │   └── data_dictionary.md
│   ├── live_nav/
│   │   ├── all_live_nav.csv
│   │   ├── AXIS_BLUECHIP.csv
│   │   ├── HDFC_TOP_100.csv
│   │   ├── ICICI_BLUECHIP.csv
│   │   ├── KOTAK_BLUECHIP.csv
│   │   ├── NIPPON_LARGE_CAP.csv
│   │   ├── SBI_BLUECHIP.csv
│   │   ├── all_live_nav.json
│   │   └── ...
│   ├── processed/
│   │   ├── clean_01_fund_master.csv
│   │   ├── clean_02_nav_history.csv
│   │   ├── clean_03_aum_by_fund_house.csv
│   │   ├── clean_04_monthly_sip_inflows.csv
│   │   ├── clean_05_category_inflows.csv
│   │   ├── clean_06_industry_folio_count.csv
│   │   ├── clean_07_scheme_performance.csv
│   │   ├── clean_08_investor_transactions.csv
│   │   ├── clean_09_portfolio_holdings.csv
│   │   └── clean_10_benchmark_indices.csv
│   └── raw/
│       ├── 01_fund_master.csv
│       ├── 02_nav_history.csv
│       ├── 03_aum_by_fund_house.csv
│       ├── 04_monthly_sip_inflows.csv
│       ├── 05_category_inflows.csv
│       ├── 06_industry_folio_count.csv
│       ├── 07_scheme_performance.csv
│       ├── 08_investor_transactions.csv
│       ├── 09_portfolio_holdings.csv
│       └── 10_benchmark_indices.csv
├── notebooks/
│   ├── 00_Database_Setup.ipynb
│   ├── 01_Data_Ingestion.ipynb
│   ├── 02_Data_Cleaning.ipynb
│   ├── 03_EDA_Analysis.ipynb
│   ├── 04_Performance_Analysis.ipynb
│   ├── 05_portfolio_analytics.ipynb
│   ├── 06_ Monte_Carlo_Simulation.ipynb
│   └── 07_Markowitz_Efficient_Frontier.ipynb
├── reports/
│   ├── charts/
│   ├── performance/
│   │   ├── alpha_beta.csv
│   │   ├── cagr_report.csv
│   │   ├── fund_scorecard.csv
│   │   ├── sortino_report.csv
│   │   └── tracking_error.csv
│   └── Portfolio Analysis/
│       └── var_cvar_report.csv
├── scripts/
│   ├── 01_live_fetch_nav.py
│   ├── 02_etl_pipeline.py
│   ├── 03_weekly_report.py
│   └── recommender.py
├── sql/
│   ├── queries.sql
│   └── schema.sql
├── requirements.txt
└── stocks/
    └── [Python virtual environment files]
```

---

## Data Sources

The raw dataset collection includes:

- `01_fund_master.csv`: scheme metadata, fund house, category, benchmark, expense ratios, risk grade
- `02_nav_history.csv`: daily NAV history for mutual fund schemes
- `03_aum_by_fund_house.csv`: fund house AUM trends and scheme counts
- `04_monthly_sip_inflows.csv`: monthly SIP inflow volume and account growth
- `05_category_inflows.csv`: category-level net inflow performance
- `06_industry_folio_count.csv`: folio count trends by asset class
- `07_scheme_performance.csv`: scheme performance and risk statistics
- `08_investor_transactions.csv`: investor transaction records and demographic segments
- `09_portfolio_holdings.csv`: portfolio stock allocations and sector exposures
- `10_benchmark_indices.csv`: benchmark index values for performance comparison

---

## Setup and Installation

### Recommended Python environment

The repository includes a Python environment folder at `stocks/`, but you can also create a fresh virtual environment:

```powershell
cd "c:\Users\Sai Khedekar\Desktop\CapstoneProject_1"
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

If the provided virtual environment is already active, you can skip environment creation.

### Key dependency list

- Python 3.13
- certifi==2026.5.20
- charset-normalizer==3.4.7
- contourpy==1.3.3
- cycler==0.12.1
- fonttools==4.63.0
- greenlet==3.5.1
- idna==3.18
- kiwisolver==1.5.0
- matplotlib==3.10.9
- narwhals==2.22.1
- numpy==2.4.6
- packaging==26.2
- pandas==3.0.3
- pillow==12.2.0
- plotly==6.8.0
- pyparsing==3.3.2
- python-dateutil==2.9.0.post0
- requests==2.34.2
- seaborn==0.13.2
- six==1.17.0
- sql==2022.4.0
- SQLAlchemy==2.0.50
- typing_extensions==4.15.0
- tzdata==2026.2
- urllib3==2.7.0

---

## Usage

### Run the ETL pipeline

The notebooks are the primary workflow for data ingestion and analysis:

- `notebooks/01_Data_Ingestion.ipynb`
- `notebooks/02_Data_Cleaning.ipynb`
- `notebooks/00_Database_Setup.ipynb`
- `notebooks/03_EDA_Analysis.ipynb`
- `notebooks/04_Performance_Analysis.ipynb`
- `notebooks/05_portfolio_analytics.ipynb`

You can also run the ETL pipeline script directly:

```powershell
python scripts/02_etl_pipeline.py
```

### Update live NAV data

```powershell
python scripts/01_live_fetch_nav.py
```

This script fetches the latest NAV values for selected bluechip schemes and appends them to `data/processed/clean_02_nav_history.csv`.

### Generate weekly HTML report

```powershell
python scripts/03_weekly_report.py
```

### Run the fund recommender

```powershell
python scripts/recommender.py
```

Enter one of the supported risk profiles when prompted: `Low`, `Moderate`, or `High`.

---

## SQL and Database

- `sql/schema.sql` defines a star schema with `dim_fund`, `dim_date`, `fact_nav`, `fact_transactions`, `fact_performance`, and `fact_aum`.
- The SQLite database file is stored at `data/db/Bluestocks_mf.db`.
- The data dictionary is available at `data/db/data_dictionary.md`.

---

## Dashboard

The Power BI dashboard deliverable is available in `dashboard/Bluestocks_mf.pbix` and `dashboard/Bluestocks_mf.pdf`.
Screenshots are included in `dashboard/Dashboard Screenshots/`.

---

## Project Highlights

- Cleaned, analytics-ready mutual fund datasets
- Live NAV ingestion and update workflow
- Performance analytics including CAGR, Sharpe, Sortino, and max drawdown
- Investor segmentation by gender, city tier, and age group
- Portfolio holdings and sector exposure analysis
- Fund recommendation engine using Sharpe risk-adjusted ranking
- Star schema SQL modeling for BI and reporting

---

## Future Enhancements

- Expand live NAV ingestion to additional schemes
- Add time-series forecasting for SIP inflows and AUM
- Build a web or Streamlit dashboard for interactive exploration
- Add automated scheduling and monitoring for daily refreshes
- Include macroeconomic and sentiment data for richer benchmarking

---

## Author

**Sai Khedekar**

Project: Mutual Fund Analytics Platform
