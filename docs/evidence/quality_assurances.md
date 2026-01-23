# Quality Assurance & Testing Strategy I used.

Beyond theoretical compliance, I verified the model through automated SQL checks within the Docker environment.

## The "Unit Testing" Approach:
* Instead of manually checking data with separate queries, I wrote an automated sanity check script (`04_sanity_checks.sql`). This acts as **Unit Testing for databases.**

* **Methodology:** Each check verifies a specific business rule (ex, "Do all students have valid classes?")  

* **Aggregation:** I used `UNION ALL` to combine multiple queries into a single, readable output. This provides a clear "PASS/FAIL" status for the entire database.

* **Real world value:** This approach caught a bug early during development (the missing 'Eva' employee record). Without automated checks, this could have gone unnoticed until production.  
  - The bug found: ![Found bug](../screenshots/bug_in_seed_script.png)  
  - [Click Here to view the documentation with bug found, bug fix and end results](output.md) 

## Verification Example: Shared PK Integrity
To prove the Super/Subtype pattern works, the script checks for "orphaned" records:
```sql
SELECT 'Students without person record', COUNT(*) ...
UNION ALL
SELECT 'Employees without person record', COUNT(*) ...
```
**Results:** 0 violations. This **proves** that the 1:1 relationship and referential integrity is intact.

## Reproducibility (Docker):  
The entire lab is containerized using Docker Compose. The environment is designed to be **idempotent:**  

* `01_ddl.sql:` Rebuilds the schema from scratch.

* `02_seed.sql:` Uses `ON CONFLICT DO NOTHING` to allow safe re-runs without data duplication.

* See `runbook_docker.md` for several quick start Docker commands or, 
[Click Here for a step by step guide on how to replicate everything.](output.md)