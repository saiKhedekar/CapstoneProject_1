import requests
import json
import pandas as pd
import os
from pathlib import Path

BASE_DIR = Path(__file__).parent.parent
RAW_DIR = BASE_DIR / "data" / "raw"
LIVE_DIR = BASE_DIR / "data" / "live_nav"
REPORT_DIR = BASE_DIR / "reports"

SCHEMES = {
    "HDFC_TOP_100":125497,
    "SBI_BLUECHIP":119551,
    "ICICI_BLUECHIP":120503,
    "NIPPON_LARGE_CAP":118632,
    "AXIS_BLUECHIP":119092,
    "KOTAK_BLUECHIP":120841
}

all_nav = []

for scheme_name, code in SCHEMES.items():

    print(f"\nFetching {scheme_name}")

    url = f"https://api.mfapi.in/mf/{code}"

    response = requests.get(url)

    data = response.json()

    with open(
        LIVE_DIR/f"{scheme_name}.json", "w"
    ) as f:

        json.dump(data,f,indent=4)

    nav_df = pd.DataFrame(
        data["data"]
    )

    nav_df["scheme_code"] = code
    nav_df["scheme_name"] = scheme_name

    nav_df.to_csv(
        LIVE_DIR/f"{scheme_name}.csv",
        index=False
    )

    all_nav.append(nav_df)

combined = pd.concat(
    all_nav,
    ignore_index=True
)

combined.to_csv(
    LIVE_DIR/"all_live_nav.csv",
    index=False
)

print("\nNAV fetch completed")