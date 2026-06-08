-- Query 1 — Top 5 Funds by AUM
SELECT
    fund_house,
    SUM(aum_crore) AS total_aum
FROM fact_aum
GROUP BY fund_house
ORDER BY total_aum DESC
LIMIT 5;


-- Query 2 — Average NAV Per Month
SELECT
    d.year,
    d.month,
    ROUND(AVG(f.nav),2) AS avg_nav
FROM fact_nav f
JOIN dim_date d
ON f.date_id = d.date_id
GROUP BY d.year,d.month
ORDER BY d.year,d.month;


-- Query 3 — SIP Inflow YoY Growth
SELECT
    d.year,
    SUM(s.sip_inflow_crore) AS total_sip
FROM fact_sip_industry s
JOIN dim_date d
ON s.date_id = d.date_id
GROUP BY d.year
ORDER BY d.year;


-- Query 4 — Transactions by State
SELECT
    state,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM fact_transactions
GROUP BY state
ORDER BY total_amount DESC;


-- Query 5 — Funds With Expense Ratio Below 1%
SELECT
    scheme_name,
    fund_house,
    expense_ratio
FROM dim_fund
WHERE expense_ratio < 1
ORDER BY expense_ratio;

    
-- Query 6 — Top 10 Performing Funds (3 Year Return)
SELECT
    f.scheme_name,
    p.return_3yr
FROM fact_performance p
JOIN dim_fund f
ON p.amfi_code=f.amfi_code
ORDER BY p.return_3yr DESC
LIMIT 10;


-- Query 7 — Best Sharpe Ratio Funds
SELECT
    f.scheme_name,
    p.sharpe
FROM fact_performance p
JOIN dim_fund f
ON p.amfi_code=f.amfi_code
ORDER BY p.sharpe DESC
LIMIT 10;



-- Query 8 — Risk Category Distribution
SELECT
    risk_grade,
    COUNT(*) AS total_funds
FROM dim_fund
GROUP BY risk_grade
ORDER BY total_funds DESC;



-- Query 9 — Fund House Market Share
SELECT
    fund_house,
    ROUND(
        100.0 *
        SUM(aum_crore) /
        (SELECT SUM(aum_crore)
         FROM fact_aum),
         2
    ) AS market_share_pct
FROM fact_aum
GROUP BY fund_house
ORDER BY market_share_pct DESC;


-- Query 10 — NAV Volatility Ranking
SELECT
    f.scheme_name,
    ROUND(
        AVG(p.std_dev),
        2
    ) AS volatility
FROM fact_performance p
JOIN dim_fund f
ON p.amfi_code=f.amfi_code
GROUP BY f.scheme_name
ORDER BY volatility DESC;


-- Top Redemption States
SELECT
    state,
    SUM(amount) AS redemption_amount
FROM fact_transactions
WHERE transaction_type='Redemption'
GROUP BY state
ORDER BY redemption_amount DESC;


-- Highest Alpha Funds
SELECT
    f.scheme_name,
    p.alpha
FROM fact_performance p
JOIN dim_fund f
ON p.amfi_code=f.amfi_code
ORDER BY p.alpha DESC;


--  Portfolio Sector Allocation
SELECT
    sector,
    ROUND(
        SUM(weight_pct),
        2
    ) AS total_weight
FROM fact_portfolio
GROUP BY sector
ORDER BY total_weight DESC;


-- 
Average SIP Amount By Age Group
SELECT
    age_group,
    ROUND(
        AVG(amount),
        2
    ) AS avg_sip
FROM fact_transactions
WHERE transaction_type='Sip'
GROUP BY age_group;