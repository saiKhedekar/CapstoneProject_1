
# 01_fund_master

- amfi_code : int64
- fund_house : str
- scheme_name : str
- category : str
- sub_category : str
- plan : str
- launch_date : str
- benchmark : str
- expense_ratio_pct : float64
- exit_load_pct : float64
- min_sip_amount : int64
- min_lumpsum_amount : int64
- fund_manager : str
- risk_category : str
- sebi_category_code : str

# 02_nav_history

- amfi_code : int64
- date : datetime64[us]
- nav : float64

# 03_aum_by_fund_house

- date : str
- fund_house : str
- aum_lakh_crore : float64
- aum_crore : int64
- num_schemes : int64

# 04_monthly_sip_inflows

- month : str
- sip_inflow_crore : int64
- active_sip_accounts_crore : float64
- new_sip_accounts_lakh : float64
- sip_aum_lakh_crore : float64
- yoy_growth_pct : float64

# 05_category_inflows

- month : str
- category : str
- net_inflow_crore : float64

# 06_industry_folio_count

- month : str
- total_folios_crore : float64
- equity_folios_crore : float64
- debt_folios_crore : float64
- hybrid_folios_crore : float64
- others_folios_crore : float64

# 07_scheme_performance

- amfi_code : int64
- scheme_name : str
- fund_house : str
- category : str
- plan : str
- return_1yr_pct : float64
- return_3yr_pct : float64
- return_5yr_pct : float64
- benchmark_3yr_pct : float64
- alpha : float64
- beta : float64
- sharpe_ratio : float64
- sortino_ratio : float64
- std_dev_ann_pct : float64
- max_drawdown_pct : float64
- aum_crore : int64
- expense_ratio_pct : float64
- morningstar_rating : int64
- risk_grade : str
- expense_ratio_flag : bool

# 08_investor_transactions

- investor_id : str
- transaction_date : datetime64[us]
- amfi_code : int64
- transaction_type : str
- amount_inr : int64
- state : str
- city : str
- city_tier : str
- age_group : str
- gender : str
- annual_income_lakh : float64
- payment_mode : str
- kyc_status : str

# 09_portfolio_holdings

- amfi_code : int64
- stock_symbol : str
- stock_name : str
- sector : str
- weight_pct : float64
- market_value_cr : float64
- current_price_inr : float64
- portfolio_date : str

# 10_benchmark_indices

- date : str
- index_name : str
- close_value : float64
