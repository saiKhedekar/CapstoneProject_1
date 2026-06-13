# ================================================
# This script fetches the latest NAVs for a set of mutual fund schemes,
# updates the NAV history, and calculates performance metrics.
# and therefore upddating the power bi dashboard with the latest data.
# ================================================

#===============================================
# For this to be automated, use windows task scheduler to run this script at a specific time every day.
# windows key + R -> taskschd.msc -> create task -> triggers -> new -> daily -> set time -> actions -> new -> start a program -> browse to python.exe and add the script path as argument.
#=================================================

import requests
import pandas as pd
import numpy as np
from datetime import datetime

# ==================================================
# CONFIG
# ==================================================

NAV_HISTORY_FILE = "data/processed/clean_02_nav_history.csv"
PERFORMANCE_FILE = "data/processed/clean_07_scheme_performance.csv"

SCHEMES = {
    125497: "HDFC Top 100 Direct",
    119551: "SBI Bluechip",
    120503: "ICICI Bluechip",
    118632: "Nippon Large Cap",
    119092: "Axis Bluechip",
    120841: "Kotak Bluechip"
}

RISK_FREE_RATE = 0.065

# ==================================================
# STEP 1 : FETCH LIVE NAV
# ==================================================

print("\nFetching latest NAVs...\n")

latest_records = []

for code, scheme in SCHEMES.items():

    try:

        url = f"https://api.mfapi.in/mf/{code}"

        response = requests.get(url, timeout=30)
        response.raise_for_status()

        data = response.json()

        latest = data["data"][0]

        latest_records.append({
            "amfi_code": code,
            "date": pd.to_datetime(
                latest["date"],
                dayfirst=True
            ),
            "nav": float(latest["nav"])
        })

        print(f"SUCCESS: {scheme}")

    except Exception as e:

        print(f"FAILED: {scheme} -> {e}")

latest_df = pd.DataFrame(latest_records)

# ==================================================
# STEP 2 : UPDATE NAV HISTORY
# ==================================================

print("\nUpdating NAV history...\n")

history = pd.read_csv(
    NAV_HISTORY_FILE
)

history["date"] = pd.to_datetime(
    history["date"]
)

history = pd.concat(
    [history, latest_df],
    ignore_index=True
)

history.drop_duplicates(
    subset=["amfi_code", "date"],
    keep="last",
    inplace=True
)

history.sort_values(
    ["amfi_code", "date"],
    inplace=True
)

history.to_csv(
    NAV_HISTORY_FILE,
    index=False
)

print("NAV history updated.")

# ==================================================
# STEP 3 : PERFORMANCE CALCULATIONS
# ==================================================

print("\nCalculating metrics...\n")

results = []

for code in history["amfi_code"].unique():

    fund = history[
        history["amfi_code"] == code
    ].copy()

    fund.sort_values(
        "date",
        inplace=True
    )

    if len(fund) < 30:
        continue

    first_nav = fund["nav"].iloc[0]
    last_nav = fund["nav"].iloc[-1]

    years = (
        fund["date"].max()
        - fund["date"].min()
    ).days / 365.25

    if years <= 0:
        continue

    cagr = (
        (last_nav / first_nav)
        ** (1 / years)
        - 1
    )

    fund["daily_return"] = (
        fund["nav"].pct_change()
    )

    returns = (
        fund["daily_return"]
        .dropna()
    )

    if len(returns) == 0:
        continue

    annual_return = (
        returns.mean() * 252
    )

    annual_vol = (
        returns.std() * np.sqrt(252)
    )

    sharpe = (
        (annual_return - RISK_FREE_RATE)
        / annual_vol
        if annual_vol > 0
        else np.nan
    )

    downside = returns[
        returns < 0
    ]

    downside_std = (
        downside.std()
        * np.sqrt(252)
    )

    sortino = (
        (annual_return - RISK_FREE_RATE)
        / downside_std
        if downside_std > 0
        else np.nan
    )

    cumulative = (
        1 + returns
    ).cumprod()

    running_max = (
        cumulative.cummax()
    )

    drawdown = (
        cumulative
        - running_max
    ) / running_max

    max_drawdown = (
        drawdown.min()
    )

    results.append({
        "amfi_code": code,
        "scheme_name": SCHEMES.get(
            code,
            str(code)
        ),
        "cagr": round(cagr * 100, 2),
        "sharpe": round(sharpe, 2),
        "sortino": round(sortino, 2),
        "max_drawdown": round(
            max_drawdown * 100,
            2
        ),
        "last_nav": round(
            last_nav,
            2
        ),
        "updated_at": datetime.now()
    })

performance = pd.DataFrame(results)

performance.to_csv(
    PERFORMANCE_FILE,
    index=False
)

# ==================================================
# STEP 4 : SUMMARY
# ==================================================

print("\n=================================")
print("ETL PIPELINE COMPLETED")
print("=================================")
print(
    f"Schemes Updated : {len(performance)}"
)
print(
    f"Last Refresh : {datetime.now()}"
)
print("=================================")