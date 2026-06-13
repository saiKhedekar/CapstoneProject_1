-- ============================================================
-- QUERY 1 : Top 5 Fund Houses by AUM
-- ============================================================

SELECT
fund_house,
SUM(aum_crore) AS total_aum
FROM fact_aum
GROUP BY fund_house
ORDER BY total_aum DESC
LIMIT 5;

-- ============================================================
-- QUERY 2 : Average NAV by Year and Month
-- ============================================================

SELECT
d.year,
d.month,
ROUND(AVG(f.nav), 2) AS avg_nav
FROM fact_nav f
JOIN dim_date d
ON f.date_key = d.date_key
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

-- ============================================================
-- QUERY 3 : Top 10 Funds by CAGR
-- ============================================================

SELECT
scheme_name,
cagr
FROM fact_performance
ORDER BY cagr DESC
LIMIT 10;

-- ============================================================
-- QUERY 4 : Top 10 Funds by Sharpe Ratio
-- ============================================================

SELECT
scheme_name,
sharpe
FROM fact_performance
ORDER BY sharpe DESC
LIMIT 10;

-- ============================================================
-- QUERY 5 : Top 10 Funds by Sortino Ratio
-- ============================================================

SELECT
scheme_name,
sortino
FROM fact_performance
ORDER BY sortino DESC
LIMIT 10;

-- ============================================================
-- QUERY 6 : Lowest Drawdown Funds
-- ============================================================

SELECT
scheme_name,
max_drawdown
FROM fact_performance
ORDER BY max_drawdown DESC
LIMIT 10;

-- ============================================================
-- QUERY 7 : Transaction Volume by State
-- ============================================================

SELECT
state,
COUNT(*) AS total_transactions,
SUM(amount_inr) AS total_amount
FROM fact_transactions
GROUP BY state
ORDER BY total_amount DESC;

-- ============================================================
-- QUERY 8 : Transaction Volume by City Tier
-- ============================================================

SELECT
city_tier,
COUNT(*) AS total_transactions,
SUM(amount_inr) AS total_amount
FROM fact_transactions
GROUP BY city_tier;

-- ============================================================
-- QUERY 9 : Investor Distribution by Gender
-- ============================================================

SELECT
gender,
COUNT(DISTINCT investor_id) AS investors
FROM fact_transactions
GROUP BY gender;

-- ============================================================
-- QUERY 10 : Investor Distribution by Age Group
-- ============================================================

SELECT
age_group,
COUNT(DISTINCT investor_id) AS investors
FROM fact_transactions
GROUP BY age_group
ORDER BY investors DESC;

-- ============================================================
-- QUERY 11 : Average Investment Amount by Age Group
-- ============================================================

SELECT
age_group,
ROUND(
AVG(amount_inr),
2
) AS avg_amount
FROM fact_transactions
GROUP BY age_group
ORDER BY avg_amount DESC;

-- ============================================================
-- QUERY 12 : Fund Category Distribution
-- ============================================================

SELECT
category,
COUNT(*) AS total_funds
FROM dim_fund
GROUP BY category
ORDER BY total_funds DESC;

-- ============================================================
-- QUERY 13 : Risk Category Distribution
-- ============================================================

SELECT
risk_category,
COUNT(*) AS total_funds
FROM dim_fund
GROUP BY risk_category
ORDER BY total_funds DESC;

-- ============================================================
-- QUERY 14 : Average Expense Ratio by Category
-- ============================================================

SELECT
category,
ROUND(
AVG(expense_ratio_pct),
2
) AS avg_expense_ratio
FROM dim_fund
GROUP BY category
ORDER BY avg_expense_ratio DESC;

-- ============================================================
-- QUERY 15 : Funds with Lowest Expense Ratio
-- ============================================================

SELECT
scheme_name,
expense_ratio_pct
FROM dim_fund
ORDER BY expense_ratio_pct
LIMIT 10;

-- ============================================================
-- QUERY 16 : Market Share by Fund House
-- ============================================================

SELECT
fund_house,

```
ROUND(
    100.0 *
    SUM(aum_crore)
    /
    (
        SELECT
            SUM(aum_crore)
        FROM fact_aum
    ),
    2
) AS market_share_pct
```

FROM fact_aum

GROUP BY fund_house

ORDER BY market_share_pct DESC;

-- ============================================================
-- QUERY 17 : Latest NAV of All Funds
-- ============================================================

SELECT
f.scheme_name,
p.last_nav
FROM fact_performance p
JOIN dim_fund f
ON p.amfi_code = f.amfi_code
ORDER BY p.last_nav DESC;

-- ============================================================
-- QUERY 18 : Highest CAGR by Fund House
-- ============================================================

SELECT
d.fund_house,
ROUND(MAX(p.cagr), 2) AS best_cagr
FROM fact_performance p
JOIN dim_fund d
ON p.amfi_code = d.amfi_code
GROUP BY d.fund_house
ORDER BY best_cagr DESC;

-- ============================================================
-- QUERY 19 : Top States by Investment Amount
-- ============================================================

SELECT
state,
ROUND(
SUM(amount_inr),
2
) AS total_investment
FROM fact_transactions
GROUP BY state
ORDER BY total_investment DESC;

-- ============================================================
-- QUERY 20 : Payment Mode Analysis
-- ============================================================

SELECT
payment_mode,
COUNT(*) AS transactions,
SUM(amount_inr) AS amount
FROM fact_transactions
GROUP BY payment_mode
ORDER BY amount DESC;
