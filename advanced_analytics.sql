-- ============================================================
-- Advanced Analytics — Indian MNC / IT Services Hiring Context
-- Extends recruitment_analysis.sql with queries relevant to
-- bulk hiring, notice-period management, and BGV pipelines
-- typical of Indian IT/BPM services organizations.
-- ============================================================

-- 1. NOTICE-PERIOD DROP-OFF: how many losses trace back to notice period issues
-- ------------------------------------------------------------
-- Notice period mismatches are one of the most common loss reasons in Indian
-- IT hiring (30/60/90-day notice periods vs. urgent open positions).
SELECT
    rejection_reason,
    COUNT(*) AS lost_candidates,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM candidates WHERE rejection_reason <> ''), 2) AS pct_of_total_losses
FROM candidates
WHERE rejection_reason IN ('Notice period too long', 'Better offer elsewhere', 'No show')
GROUP BY rejection_reason
ORDER BY lost_candidates DESC;


-- 2. BULK HIRING VELOCITY: applications and joins per month, per department
-- ------------------------------------------------------------
-- Useful for tracking whether a department is on pace for a hiring target
-- (common in campus/bulk hiring drives with monthly headcount goals).
SELECT
    department,
    strftime('%Y-%m', application_date) AS month,   -- MySQL: DATE_FORMAT(application_date,'%Y-%m')
    COUNT(*) AS applications,
    SUM(CASE WHEN status = 'Joined' THEN 1 ELSE 0 END) AS joins
FROM candidates
GROUP BY department, month
ORDER BY department, month;


-- 3. OFFER-TO-JOINING LEAKAGE (proxy for BGV / pre-onboarding drop-off)
-- ------------------------------------------------------------
-- In Indian MNC hiring, a meaningful share of "Offer Declined" status is
-- actually BGV-stage attrition or a competing offer surfacing during the
-- (often 30-45 day) notice period gap between offer and joining.
SELECT
    department,
    COUNT(offer_date) AS total_offers,
    SUM(CASE WHEN status = 'Joined' THEN 1 ELSE 0 END) AS actually_joined,
    SUM(CASE WHEN status = 'Offer Declined' THEN 1 ELSE 0 END) AS lost_after_offer,
    ROUND(100.0 * SUM(CASE WHEN status = 'Offer Declined' THEN 1 ELSE 0 END) / NULLIF(COUNT(offer_date),0), 2) AS post_offer_leakage_pct
FROM candidates
GROUP BY department
HAVING COUNT(offer_date) > 0
ORDER BY post_offer_leakage_pct DESC;


-- 4. COST-PER-HIRE BY SOURCE (assumes a cost_inputs table you populate)
-- ------------------------------------------------------------
-- Companion query for the Cost-per-Hire calculator (cost_per_hire_calculator.html).
-- Create a small assumptions table with your actual monthly channel spend:
--
-- CREATE TABLE cost_inputs (
--     source          VARCHAR(50) PRIMARY KEY,
--     monthly_cost    DECIMAL(10,2)   -- job board fee, agency fee, referral payout, sourcer time, etc.
-- );
--
-- Then cost-per-hire per channel is:
SELECT
    c.source,
    COUNT(*) AS hires,
    ci.monthly_cost,
    ROUND(ci.monthly_cost / COUNT(*), 2) AS cost_per_hire
FROM candidates c
JOIN cost_inputs ci ON ci.source = c.source
WHERE c.status = 'Joined'
GROUP BY c.source, ci.monthly_cost
ORDER BY cost_per_hire ASC;


-- 5. CAMPUS VS. LATERAL HIRING MIX
-- ------------------------------------------------------------
-- A common leadership-level question: what % of hires are freshers
-- (campus) vs. experienced lateral hires, and how does time-to-hire differ.
SELECT
    CASE WHEN source = 'Campus Drive' THEN 'Campus (Fresher)' ELSE 'Lateral' END AS hire_type,
    COUNT(*) AS total_joined,
    ROUND(AVG(time_to_hire_days), 1) AS avg_time_to_hire_days
FROM candidates
WHERE status = 'Joined'
GROUP BY hire_type;
