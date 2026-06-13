# ==================================================
# GMAIL APP PASSWORD SETUP
# ==================================================
#
# Gmail does NOT allow Python applications to log in
# using your normal Gmail account password.
#
# Follow these steps:
#
# 1. Open your Google Account
#    https://myaccount.google.com
#
# 2. Go to:
#    Security → 2-Step Verification
#
# 3. Enable 2-Step Verification
#
# 4. Search for:
#    App Passwords
#
# 5. Create a new App Password
#
#    App Name:
#    Mutual Fund Report
#
# 6. Google will generate a 16-character password:
#
#    Example:
#    abcd efgh ijkl mnop
#
# 7. Copy the generated password and paste it below:
#
#    APP_PASSWORD = "abcdefghijklmnop"
#
# 8. For automation, Use windows task scheduler or cron job to run this script weekly.
#
#
#
# IMPORTANT:
# - Do NOT use your normal Gmail password.
# - Do NOT upload App Passwords to GitHub.
# - If an App Password is exposed, revoke it and
#   generate a new one immediately.
#
# ==================================================



import os
import pandas as pd
import smtplib

from datetime import datetime
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# ==================================================

# CONFIG

# ==================================================

PERFORMANCE_FILE = "data/processed/clean_07_scheme_performance.csv"

REPORT_DIR = "reports"

REPORT_FILE = f"{REPORT_DIR}/weekly_report.html"

SENDER_EMAIL = ""

RECEIVER_EMAIL = "" 

APP_PASSWORD = "Enter generated app password here"

# ==================================================

# CREATE REPORT DIRECTORY

# ==================================================

os.makedirs(
REPORT_DIR,
exist_ok=True
)

# ==================================================

# LOAD DATA

# ==================================================

df = pd.read_csv(PERFORMANCE_FILE)

print("Performance data loaded")

# ==================================================

# KPI CALCULATIONS

# ==================================================

total_funds = len(df)

avg_cagr = round(
df["cagr"].mean(),
2
)

avg_sharpe = round(
df["sharpe"].mean(),
2
)

avg_sortino = round(
df["sortino"].mean(),
2
)

avg_drawdown = round(
df["max_drawdown"].mean(),
2
)

best_fund = df.loc[
df["cagr"].idxmax(),
"scheme_name"
]

best_cagr = round(
df["cagr"].max(),
2
)

highest_sharpe_fund = df.loc[
df["sharpe"].idxmax(),
"scheme_name"
]

highest_sharpe = round(
df["sharpe"].max(),
2
)

highest_sortino_fund = df.loc[
df["sortino"].idxmax(),
"scheme_name"
]

highest_sortino = round(
df["sortino"].max(),
2
)

lowest_drawdown_fund = df.loc[
df["max_drawdown"].idxmax(),
"scheme_name"
]

lowest_drawdown = round(
df["max_drawdown"].max(),
2
)

top_cagr = df.nlargest(
5,
"cagr"
)

top_sharpe = df.nlargest(
5,
"sharpe"
)

report_date = datetime.now().strftime(
"%d %B %Y"
)

# ==================================================

# GENERATE HTML REPORT

# ==================================================

html = f"""

<!DOCTYPE html>

<html>

<head>

<title>Weekly Mutual Fund Report</title>

<style>

body {{
    font-family: Arial, sans-serif;
    margin: 40px;
}}

h1 {{
    color: #1F4E79;
}}

h2 {{
    color: #1F4E79;
}}

.card {{
    background-color: #f5f5f5;
    padding: 15px;
    margin-bottom: 20px;
    border-left: 5px solid #1F4E79;
}}

table {{
    width: 100%;
    border-collapse: collapse;
}}

th {{
    background-color: #1F4E79;
    color: white;
    padding: 10px;
}}

td {{
    border: 1px solid #ddd;
    padding: 8px;
}}

</style>

</head>

<body>

<h1>
Weekly Mutual Fund Performance Report
</h1>

<p>
Generated On: {report_date}
</p>

<hr>

<div class="card">

<h2>Industry Snapshot</h2>

<ul>

<li><b>Total Funds Analysed:</b> {total_funds}</li>

<li><b>Average CAGR:</b> {avg_cagr}%</li>

<li><b>Average Sharpe Ratio:</b> {avg_sharpe}</li>

<li><b>Average Sortino Ratio:</b> {avg_sortino}</li>

<li><b>Average Max Drawdown:</b> {avg_drawdown}%</li>

</ul>

</div>

<div class="card">

<h2>Top Fund Metrics</h2>

<ul>

<li>
<b>Highest CAGR Fund:</b>
{best_fund}
({best_cagr}%)
</li>

<li>
<b>Highest Sharpe Fund:</b>
{highest_sharpe_fund}
({highest_sharpe})
</li>

<li>
<b>Highest Sortino Fund:</b>
{highest_sortino_fund}
({highest_sortino})
</li>

<li>
<b>Lowest Drawdown Fund:</b>
{lowest_drawdown_fund}
({lowest_drawdown}%)
</li>

</ul>

</div>

<h2>
Top 5 Funds by CAGR
</h2>

{top_cagr.to_html(index=False)}

<br><br>

<h2>
Top 5 Funds by Sharpe Ratio
</h2>

{top_sharpe.to_html(index=False)}

<hr>

<p>
Generated automatically by the Mutual Fund Analytics Platform
</p>

</body>

</html>
"""

# ==================================================

# SAVE HTML REPORT

# ==================================================

with open(
    REPORT_FILE,"w",
encoding="utf-8"
) as f:

    f.write(html)


print("HTML report generated")

# ==================================================

# SEND EMAIL

# ==================================================

with open(
REPORT_FILE,
"r",
encoding="utf-8"
) as f:


    html_body = f.read()


msg = MIMEMultipart()

msg["Subject"] = "Weekly Mutual Fund Performance Report"

msg["From"] = SENDER_EMAIL

msg["To"] = RECEIVER_EMAIL

msg.attach(
MIMEText(
html_body,
"html"
)
)

try:

    server = smtplib.SMTP(
        "smtp.gmail.com",
        587
    )

    server.starttls()

    server.login(
        SENDER_EMAIL,
        APP_PASSWORD
    )

    server.send_message(msg)

    server.quit()

    print("Email sent successfully")

except Exception as e:

    print("Email sending failed")
    print(e)


print("Weekly report completed")
