# Database Assignment 3 — Query, Change & Tune Data

**Name:** Marwan Esam  

## Repository Structure

- `sql/` — SQL scripts for Tasks 1–9 and 11–13 (Task 10 is written-only in `NOTES.md`).
- `screenshots/` — Execution plans, `STATISTICS IO/TIME`, and operator properties screenshots for Tasks 6–9.
- `NOTES.md` — Written answers, execution plan explanations, before/after logical reads, and design trade-offs for Tasks 1–13.

## How to Run the Files

1. Connect to your local copy of `LmsTrainingLab` in SSMS, Azure Data Studio, VS Code (MSSQL), or DBeaver.
2. Execute the scripts inside `sql/` **in numerical order** (`01_finance_meeting.sql` → `13_website_sync.sql`):
   - `02_new_department.sql` creates `DSAI`, `DSAI-101`, `SUMMER 2027`, the announcement, and `TEACHING_ASSISTANT` (used by Tasks 4, 11, 12, and 13).
   - `07_make_it_faster.sql` creates the 5 production indexes at the top of the file once, then runs the before/after tuning queries with `SET STATISTICS IO, TIME ON`.
   - `08_sort_spill.sql` creates `dbo.SpillDemo` (reused by `09_one_of_each.sql` and cleaned up in `11_end_of_semester.sql`).
3. Enable **Include Actual Execution Plan** when running `06_reading_the_plan.sql`, `07_make_it_faster.sql`, `08_sort_spill.sql`, and `09_one_of_each.sql`.
