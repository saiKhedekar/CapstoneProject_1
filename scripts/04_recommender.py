"""
recommender.py
--------------
Standalone mutual fund recommender.
Input  : risk appetite � Low | Moderate | High
Output : Top-3 funds by Sharpe ratio within the matching risk grade.

Usage:
    python recommender.py
    # or import and call recommend_funds() directly
"""

import pandas as pd
import numpy as np
import sys
import os

# Make data paths relative to this script file so running from project root works
BASE_DIR = os.path.dirname(__file__)
DATA_DIR = os.getenv("DATA_DIR", os.path.join(BASE_DIR, "..", "data", "processed"))
RAW_DIR = os.getenv("RAW_DIR", os.path.join(BASE_DIR, "..", "data", "raw"))

RF_DAILY  = 0.065 / 252   # 6.5% annualised risk-free rate


def load_data():
    nav   = pd.read_csv(f"{DATA_DIR}/clean_02_nav_history.csv", parse_dates=["date"])
    funds = pd.read_csv(f"{RAW_DIR}/01_fund_master.csv")
    return nav, funds


def compute_sharpe(nav: pd.DataFrame) -> pd.DataFrame:
    nav = nav.sort_values(["amfi_code", "date"])
    nav["daily_return"] = nav.groupby("amfi_code")["nav"].pct_change()

    rows = []
    for code, grp in nav.groupby("amfi_code"):
        r = grp["daily_return"].dropna()
        if len(r) < 50:
            continue
        sharpe = ((r.mean() - RF_DAILY) / r.std()) * np.sqrt(252)
        rows.append({"amfi_code": code, "Sharpe": round(sharpe, 4)})
    return pd.DataFrame(rows)


def build_recommend_df(sharpe_df: pd.DataFrame, funds: pd.DataFrame) -> pd.DataFrame:
    risk_col_candidates = [c for c in funds.columns
                           if any(kw in c.lower() for kw in ["risk", "grade"])]
    risk_col = risk_col_candidates[0] if risk_col_candidates else "risk_category"
    df = sharpe_df.merge(
        funds[["amfi_code", risk_col, "scheme_name"]].rename(
            columns={risk_col: "risk_grade"}),
        on="amfi_code", how="left"
    )
    return df


def recommend_funds(risk_level: str, top_n: int = 3,
                    recommend_df: pd.DataFrame = None) -> pd.DataFrame:
    """Return top-N funds by Sharpe within risk_level."""
    if recommend_df is None:
        nav, funds = load_data()
        sharpe_df  = compute_sharpe(nav)
        recommend_df = build_recommend_df(sharpe_df, funds)

    result = (
        recommend_df[recommend_df["risk_grade"] == risk_level]
        .sort_values("Sharpe", ascending=False)
        .head(top_n)[["scheme_name", "risk_grade", "Sharpe"]]
        .reset_index(drop=True)
    )
    result.index    = result.index + 1
    result.index.name = "Rank"
    return result


def main():
    valid = ["Low", "Moderate", "High"]
    if len(sys.argv) > 1:
        risk_level = sys.argv[1].capitalize()
    else:
        print("Enter risk appetite (Low / Moderate / High): ", end="")
        risk_level = input().strip().capitalize()

    if risk_level not in valid:
        print(f"Invalid risk level. Choose from: {valid}")
        sys.exit(1)

    nav, funds   = load_data()
    sharpe_df    = compute_sharpe(nav)
    recommend_df = build_recommend_df(sharpe_df, funds)

    result = recommend_funds(risk_level, recommend_df=recommend_df)
    print(f"\nTop 3 Funds � {risk_level} Risk:")
    print("=" * 55)
    print(result.to_string())


if __name__ == "__main__":
    main()
