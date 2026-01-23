# Verification via Automated Sanity Checks

Beyond theoretical compliance, I verified 3NF through automated SQL checks:

## Check 3: Subtype Inheritance (Shared PK Verification)
```sql
SELECT 'Students without person record', COUNT(*)
FROM student s
LEFT JOIN person p ON s.person_id = p.person_id
WHERE p.person_id IS NULL

UNION ALL

SELECT 'Employees without person record', COUNT(*)
FROM employee e
LEFT JOIN person p ON e.person_id = p.person_id
WHERE p.person_id IS NULL;
```
**Result:** 0 violations 

## **What this proves:**
- Shared PK pattern enforced (no orphaned subtypes)
- 1:1(one to one) relationship maintained (person <--> student/employee)
- Referential integrity intact (all FKs valid)

[Screenshot: 04_sanity_checks.sql output showing everything is okay]

This test driven approach ensures design compliance isn't just theoretical, it is continuously validated.


---

**UNION ALL i sanity checks:**
- **Kombinerar** multiple checks into one readable output
- **Behåller** all rows (not removing "duplicates" like UNION)
- **Requires** same column count + types across queries
- **Creates** test suite summary (like Python unittest output)

**Inte "två queries testade mot varandra"** det är **flera separata tests kombinerade för readability!**

**Unit testing analogy:**
```
Python:     test1() -> PASS, test2() --> PASS (sequential execution)  
SQL:        query1 UNION ALL query2 --> all results at once (parallel results)
```

## Sanity checks / Unit testing  
Instead of manually checking data integrity, I wrote automated sanity checks, this is like unit tests but for databases.  

**Each check verifies a business rule:**  
'Do all students have valid classes?' 'Do all teaching assignments have educators?'

I used UNION ALL to combine multiple checks into one output instead of 23 separate queries. This way I get one comprehensive report showing all violations (or in this case, zero violations).

This approach caught a bug early: Eva was missing from the employee table. Without automated checks, this could have gone unnoticed until production. Test driven development saves time!