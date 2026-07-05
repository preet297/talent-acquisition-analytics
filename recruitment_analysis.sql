-- ============================================================
-- Talent Acquisition Analytics Project
-- Schema + Analytical Queries
-- Works in MySQL / PostgreSQL / SQLite (minor syntax tweaks may be needed)
-- ============================================================

-- 1. SCHEMA
-- ------------------------------------------------------------
CREATE TABLE candidates (
    candidate_id        INT PRIMARY KEY,
    name                VARCHAR(100),
    source              VARCHAR(50),       -- LinkedIn, Naukri, Referral, Campus Drive, Indeed, Company Website
    role_applied        VARCHAR(100),
    department          VARCHAR(50),
    application_date    DATE,
    screening_date      DATE,
    interview_date      DATE,
    offer_date          DATE,
    joining_date        DATE,
    status              VARCHAR(30),       -- Rejected, Offer Declined, Joined
    rejection_reason    VARCHAR(100),
    time_to_hire_days   INT
);

-- Import candidates.csv into this table using your DB's import tool, e.g.:
--   MySQL:   LOAD DATA LOCAL INFILE 'candidates.csv' INTO TABLE candidates
--            FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
--   Postgres: \copy candidates FROM 'candidates.csv' WITH (FORMAT csv, HEADER true)
--   SQLite:   .mode csv  /  .import candidates.csv candidates


-- 2. FUNNEL CONVERSION: how many candidates reach each stage
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_applied,
    COUNT(screening_date)  AS screened,
    COUNT(interview_date)  AS interviewed,
    COUNT(offer_date)      AS offered,
    COUNT(joining_date)    AS joined
FROM candidates;


-- 3. SOURCE-WISE CONVERSION RATE (Applied -> Joined)
-- ------------------------------------------------------------
SELECT
    source,
    COUNT(*) AS total_applied,
    SUM(CASE WHEN status = 'Joined' THEN 1 ELSE 0 END) AS total_joined,
    ROUND(100.0 * SUM(CASE WHEN status = 'Joined' THEN 1 ELSE 0 END) / COUNT(*), 2) AS conversion_rate_pct
FROM candidates
GROUP BY source
ORDER BY conversion_rate_pct DESC;


-- 4. AVERAGE TIME-TO-HIRE BY DEPARTMENT
-- ------------------------------------------------------------
SELECT
    department,
    ROUND(AVG(time_to_hire_days), 1) AS avg_time_to_hire_days,
    COUNT(*) AS candidates_joined
FROM candidates
WHERE status = 'Joined'
GROUP BY department
ORDER BY avg_time_to_hire_days ASC;


-- 5. TOP REJECTION REASONS (where are we losing candidates)
-- ------------------------------------------------------------
SELECT
    rejection_reason,
    COUNT(*) AS count_candidates,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM candidates WHERE rejection_reason <> ''), 2) AS pct_of_all_losses
FROM candidates
WHERE rejection_reason <> ''
GROUP BY rejection_reason
ORDER BY count_candidates DESC;


-- 6. OFFER-TO-JOIN DROP OFF (accepted offer but didn't join = "Offer Declined")
-- ------------------------------------------------------------
SELECT
    source,
    SUM(CASE WHEN status = 'Offer Declined' THEN 1 ELSE 0 END) AS offers_declined,
    COUNT(offer_date) AS total_offers_made,
    ROUND(100.0 * SUM(CASE WHEN status = 'Offer Declined' THEN 1 ELSE 0 END) / NULLIF(COUNT(offer_date),0), 2) AS decline_rate_pct
FROM candidates
GROUP BY source
HAVING COUNT(offer_date) > 0
ORDER BY decline_rate_pct DESC;


-- 7. MONTHLY APPLICATION TREND
-- ------------------------------------------------------------
SELECT
    strftime('%Y-%m', application_date) AS month,   -- MySQL: DATE_FORMAT(application_date, '%Y-%m')
    COUNT(*) AS applications_received
FROM candidates
GROUP BY month
ORDER BY month;


-- 8. BEST ROLE-SOURCE COMBINATION (which source works best for which role)
-- ------------------------------------------------------------
SELECT
    role_applied,
    source,
    COUNT(*) AS applied,
    SUM(CASE WHEN status = 'Joined' THEN 1 ELSE 0 END) AS joined,
    ROUND(100.0 * SUM(CASE WHEN status = 'Joined' THEN 1 ELSE 0 END) / COUNT(*), 2) AS conversion_pct
FROM candidates
GROUP BY role_applied, source
HAVING COUNT(*) >= 5
ORDER BY conversion_pct DESC
LIMIT 10;
