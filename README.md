# Talent Acquisition Analytics Project

A complete, end-to-end Talent Acquisition portfolio — built to demonstrate
sourcing, data analysis, cost modeling, and structured hiring evaluation
skills for TA/recruiter roles at Indian MNCs (TCS, Infosys, Wipro, Accenture,
Cognizant, HCL, Capgemini and similar IT/BPM services organizations).

**Live dashboard:** https://preet297.github.io/talent-acquisition-analytics/dashboard.html
**Live cost calculator:** https://preet297.github.io/talent-acquisition-analytics/cost_per_hire_calculator.html

---

## What's inside

| File | What it is |
|---|---|
| `candidates.csv` | Synthetic dataset — 320 candidate records across 6 sourcing channels, 8 roles, full funnel dates |
| `dashboard.html` | Interactive recruitment funnel dashboard — conversion, time-to-hire, drop-off reasons, trend |
| `cost_per_hire_calculator.html` | Interactive cost-per-hire & channel ROI tool — enter your own budget assumptions |
| `recruitment_analysis.sql` | Core SQL — schema + 8 funnel/conversion/time-to-hire queries |
| `advanced_analytics.sql` | Extended SQL — notice-period drop-off, bulk hiring velocity, BGV/offer leakage, campus vs. lateral mix, cost-per-hire join |
| `sourcing_toolkit.md` | Job descriptions + Boolean search strings (LinkedIn, Naukri) for 5 common roles |
| `interview_scorecard_template.docx` | Structured, competency-based interview evaluation template with notice-period, CTC, relocation, and BGV fields |

## Why this is built for Indian MNC / IT services hiring specifically

Most student TA portfolios stop at "sourcing + screening." Indian MNC/IT
services recruiting has a few things that make it distinct, and this project
addresses each one directly:

- **Notice period is a first-class variable**, not an afterthought — the
  scorecard captures it explicitly, and `advanced_analytics.sql` isolates
  notice-period-driven losses separately from other rejection reasons
- **BGV (background verification) sits between offer and joining** and is a
  real source of attrition — modeled as "offer-to-joining leakage" in the
  advanced queries
- **Bulk and campus hiring run on monthly velocity targets**, not just
  overall funnel health — the monthly velocity query and campus-vs-lateral
  split reflect that
- **Cost-per-hire and vendor/channel ROI** matter more at scale — most
  student projects never touch this; this one has a dedicated interactive
  calculator

## How to use this for your resume

**Resume line (pick one):**
- "Built an end-to-end Talent Acquisition analytics suite — recruitment funnel dashboard, cost-per-hire calculator, and SQL-based hiring analysis — modeling notice-period attrition and BGV drop-off patterns typical of high-volume IT services hiring."
- "Designed SQL queries and interactive dashboards analyzing 320+ candidates across 6 sourcing channels; built a cost-per-hire calculator identifying the most efficient sourcing channel and a structured interview scorecard to standardize hiring decisions."

**Where to host it:** already done — GitHub Pages is live at the links above.
Put both links directly on your resume as clickable text, not just "GitHub
profile available on request."

## Talking points for interviews (STAR-ready)

**"Tell me about a data project you've done."**
> I built a recruitment analytics suite modeling a 320-candidate hiring
> pipeline across 6 sourcing channels. I used SQL to calculate conversion
> rates, time-to-hire, and drop-off reasons, then built an interactive
> dashboard so the numbers are usable by someone without SQL access — a
> hiring manager or TA lead can just open the dashboard.

**"Why does cost-per-hire matter, and how would you improve it?"**
> Cost-per-hire tells you whether your sourcing spend is actually
> efficient, not just whether a channel produces volume. In my model,
> referrals had a lower cost-per-hire than paid job boards, so the
> recommendation is to shift incremental budget toward referral incentives
> before increasing paid sourcing spend.

**"How do you handle candidates who drop off due to notice period or BGV?"**
> I'd track it as a separate funnel stage rather than lumping it into
> generic "rejected" — that's what my `advanced_analytics.sql` does. If
> notice-period mismatch is a top-3 loss reason, the fix isn't sourcing
> more candidates, it's either building a longer-lead pipeline for urgent
> roles or negotiating buyout options with hiring managers upfront.

**"How would you evaluate a candidate consistently across interviewers?"**
> Using a structured scorecard like the one I built — fixed competencies,
> a 1-5 rating scale, and a mandatory evidence/notes field so a "hire"
> decision is traceable to something specific the candidate said or did,
> not just a gut feeling.

**"How would you extend this with real company data?"**
> Swap `candidates.csv` for an actual ATS export (Workday, SuccessFactors,
> Darwinbox, or similar are common at Indian MNCs) — the same SQL queries,
> dashboard logic, and scorecard apply directly with no redesign needed.

## Making it your own (recommended before adding to resume)

- Regenerate the dataset with a different seed/numbers so it isn't
  identical to another candidate's version of this project
- If you have any real (anonymized) placement cell, internship
  recruitment, or event-volunteer coordination numbers, swap those in —
  real numbers, even small scale, are always stronger than synthetic ones
- Fill in the `cost_inputs` table in `advanced_analytics.sql` with a
  plausible cost structure and mention it explicitly if asked how you
  arrived at the numbers
- Practice walking through the dashboard live — screen-share it in a
  virtual interview or pull it up on your phone in person
