# IT Service Desk Analytics: Ticket Resolution & SLA Optimization

## Project status
Portfolio-ready analysis using a **synthetic dataset** generated with a fixed random seed. It is not company data and should not be presented as measured results from a real employer.

## Business problem
IT support teams need to understand which ticket categories, priorities, and assigned teams are associated with SLA breaches and slow resolution. The goal is to turn ticket-level records into operational insights.

## Tools
- SQL (SQLite): KPI queries, grouped analysis, bottleneck analysis
- Python (pandas): data validation, analysis, database creation
- Power BI: recommended dashboard build using the supplied CSV or SQLite outputs
- GitHub: project versioning and documentation

## Dataset
- Records: 3,000 tickets
- Date range: 2026-01-01 to 2026-09-30
- Fields: ticket_id, created_at, department, priority, issue_category, assigned_team, status, resolution_hours, sla_target_hours, sla_status
- SLA thresholds used for this exercise: Critical 4h, High 8h, Medium 24h, Low 48h. These are illustrative project assumptions, not an industry standard.

## Findings from this synthetic dataset
- Total tickets: **3,000**
- Resolved tickets: **2,853**; open tickets: **147**
- Overall SLA compliance: **69.4%**
- Average resolution time for resolved tickets: **15.58 hours**
- Median resolution time for resolved tickets: **11.21 hours**
- Category with highest SLA breach rate: **Network (48.8%)**
- Team with highest SLA breach rate: **Applications (37.6%)**

These are results of the generated sample data only. Re-run the analysis if you change the dataset.

## Recommended business actions to test
1. Review high-breach issue categories and separate recurring incidents from one-off tickets.
2. Check whether breached tickets cluster around specific shifts, teams, departments, or priority levels.
3. Create an escalation queue for tickets approaching their SLA target.
4. Review workload and specialist routing for teams with persistent backlogs.
5. Track SLA compliance weekly after any operational change; compare like-for-like periods before claiming improvement.

## Power BI dashboard pages
1. **Executive overview:** Total tickets, Open tickets, Average resolution hours, SLA compliance %.
2. **Bottleneck analysis:** SLA breach rate and average resolution time by issue category.
3. **Team performance:** ticket volume, open backlog, and breach rate by assigned team.
4. **Trends:** monthly ticket count and SLA breach rate.
5. **Drill-through:** ticket detail table with priority, category, team, status, and SLA status.

## How to run
1. Install Python 3 and packages: `pandas`.
2. Run `python run_analysis.py` from this folder.
3. Open `analysis_queries.sql` in SQLite or DB Browser for SQLite.
4. Import `it_support_tickets_synthetic.csv` into Power BI and build the pages listed above.

## Resume bullet (be transparent about synthetic data)
**IT Service Desk Analytics | SQL, Python, Power BI** — Analyzed 3,000 synthetic IT support tickets using SQL and Python to evaluate SLA compliance, resolution times, and backlog by issue category and team; developed actionable recommendations for ticket triage and escalation.
