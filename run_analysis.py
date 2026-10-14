import sqlite3
import pandas as pd
from pathlib import Path

ROOT = Path(__file__).parent
csv_path = ROOT / "it_support_tickets_synthetic.csv"
db_path = ROOT / "it_service_desk.db"

df = pd.read_csv(csv_path)
df["created_at"] = pd.to_datetime(df["created_at"], errors="coerce")
df["resolution_hours"] = pd.to_numeric(df["resolution_hours"], errors="coerce")

# Basic validation checks
checks = {
    "row_count": len(df),
    "duplicate_ticket_ids": int(df["ticket_id"].duplicated().sum()),
    "missing_ticket_ids": int(df["ticket_id"].isna().sum()),
    "missing_created_at": int(df["created_at"].isna().sum()),
}
print("DATA QUALITY CHECKS")
for key, value in checks.items():
    print(f"{key}: {value}")

with sqlite3.connect(db_path) as conn:
    df.to_sql("tickets", conn, if_exists="replace", index=False)

with sqlite3.connect(db_path) as conn:
    kpis = pd.read_sql_query("""
        SELECT COUNT(*) total_tickets,
               SUM(CASE WHEN status='Resolved' THEN 1 ELSE 0 END) resolved_tickets,
               SUM(CASE WHEN status='Open' THEN 1 ELSE 0 END) open_tickets,
               ROUND(100.0*SUM(CASE WHEN sla_status='Met' THEN 1 ELSE 0 END)/COUNT(*),2) sla_compliance_pct
        FROM tickets
    """, conn)
print("\\nKPI SUMMARY")
print(kpis.to_string(index=False))

print("\\nCATEGORY ANALYSIS")
print(pd.read_sql_query("""
    SELECT issue_category, COUNT(*) tickets,
           ROUND(AVG(resolution_hours),2) avg_resolution_hours,
           ROUND(100.0*SUM(CASE WHEN sla_status='Breached' THEN 1 ELSE 0 END)/COUNT(*),1) breach_rate_pct,
           SUM(CASE WHEN status='Open' THEN 1 ELSE 0 END) open_tickets
    FROM tickets GROUP BY issue_category ORDER BY breach_rate_pct DESC
""", conn).to_string(index=False))
print(f"\\nSQLite database saved to: {db_path}")
