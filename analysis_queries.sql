-- IT Service Desk Analytics: SQL queries
-- Compatible with SQLite. Dataset is synthetic and intended for portfolio practice.

-- 1. Overall KPI summary
SELECT
  COUNT(*) AS total_tickets,
  SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) AS resolved_tickets,
  SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END) AS open_tickets,
  ROUND(100.0 * SUM(CASE WHEN sla_status = 'Met' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_compliance_pct
FROM tickets;

-- 2. Average and median resolution time (SQLite has no built-in MEDIAN)
SELECT
  ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours
FROM tickets
WHERE status = 'Resolved';

-- 3. Category-level bottlenecks
SELECT
  issue_category,
  COUNT(*) AS ticket_count,
  ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,
  ROUND(100.0 * SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_breach_rate_pct,
  SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END) AS open_tickets
FROM tickets
GROUP BY issue_category
ORDER BY sla_breach_rate_pct DESC;

-- 4. SLA breaches by priority
SELECT
  priority,
  COUNT(*) AS ticket_count,
  ROUND(100.0 * SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_breach_rate_pct
FROM tickets
GROUP BY priority
ORDER BY CASE priority
  WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 WHEN 'Medium' THEN 3 ELSE 4 END;

-- 5. Team performance
SELECT
  assigned_team,
  COUNT(*) AS ticket_count,
  ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,
  ROUND(100.0 * SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_breach_rate_pct,
  SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END) AS open_tickets
FROM tickets
GROUP BY assigned_team
ORDER BY sla_breach_rate_pct DESC;

-- 6. Monthly ticket trend
SELECT
  strftime('%Y-%m', created_at) AS month,
  COUNT(*) AS ticket_count,
  ROUND(100.0 * SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_breach_rate_pct
FROM tickets
GROUP BY strftime('%Y-%m', created_at)
ORDER BY month;
