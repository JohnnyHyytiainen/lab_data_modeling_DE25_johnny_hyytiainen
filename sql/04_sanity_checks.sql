-- ========================================
-- YrkesCo Database - Data Quality & Sanity Checks
-- Purpose: Verify referential integrity and business rules
-- Expected result: 0 violations for all checks
-- ========================================

\echo ''
\echo '######################################'
\echo '# YRKESCO DATABASE - SANITY CHECKS  #'
\echo '######################################'
\echo ''

-- ========================================
-- Check 1: Referential Integrity - No Orphans
-- ========================================
\echo '====================================='
\echo 'Check 1: Referential Integrity'
\echo 'Purpose: Verify no broken foreign keys'
\echo 'Expected: 0 violations for all rows'
\echo '====================================='

SELECT 
  'Students without class' AS check_type,
  COUNT(*) AS violations
FROM student s
LEFT JOIN class c ON s.class_id = c.class_id
WHERE c.class_id IS NULL

UNION ALL

SELECT 
  'Classes without manager',
  COUNT(*)
FROM class c
LEFT JOIN employee e ON c.managed_by_employee_person_id = e.person_id
WHERE e.person_id IS NULL

UNION ALL

SELECT 
  'Teaching assignments without educator',
  COUNT(*)
FROM teaching_assignment ta
LEFT JOIN educator ed ON ta.educator_person_id = ed.person_id
WHERE ed.person_id IS NULL

UNION ALL

SELECT 
  'Teaching assignments without class',
  COUNT(*)
FROM teaching_assignment ta
LEFT JOIN class c ON ta.class_id = c.class_id
WHERE c.class_id IS NULL

UNION ALL

SELECT 
  'Teaching assignments without course',
  COUNT(*)
FROM teaching_assignment ta
LEFT JOIN course cr ON ta.course_id = cr.course_id
WHERE cr.course_id IS NULL

UNION ALL

SELECT 
  'Consultants without company',
  COUNT(*)
FROM consultant co
LEFT JOIN consultant_company cc ON co.consultant_company_id = cc.consultant_company_id
WHERE cc.consultant_company_id IS NULL;

-- Expected output: All rows show 0 violations
-- Proves FK constraints are working

\echo ''

-- ========================================
-- Check 2: Person Role Assignment
-- ========================================
\echo '====================================='
\echo 'Check 2: Person Role Assignment'
\echo 'Purpose: Verify all persons have at least one role'
\echo 'Expected: 0 persons without role'
\echo '====================================='

SELECT 
  'Persons without any role' AS check_type,
  COUNT(*) AS violations
FROM person p
LEFT JOIN student s ON p.person_id = s.person_id
LEFT JOIN employee emp ON p.person_id = emp.person_id
LEFT JOIN educator ed ON p.person_id = ed.person_id
WHERE s.person_id IS NULL 
  AND emp.person_id IS NULL 
  AND ed.person_id IS NULL;

-- Expected: 0 violations
-- Proves person ->role relationship is complete

\echo ''

-- ========================================
-- Check 3: Subtype Inheritance (Shared PK)
-- ========================================
\echo '====================================='
\echo 'Check 3: Subtype Inheritance'
\echo 'Purpose: Verify all subtypes reference valid person_id'
\echo 'Expected: 0 violations'
\echo '====================================='

SELECT 
  'Students without person record' AS check_type,
  COUNT(*) AS violations
FROM student s
LEFT JOIN person p ON s.person_id = p.person_id
WHERE p.person_id IS NULL

UNION ALL

SELECT 
  'Employees without person record',
  COUNT(*)
FROM employee e
LEFT JOIN person p ON e.person_id = p.person_id
WHERE p.person_id IS NULL

UNION ALL

SELECT 
  'Educators without person record',
  COUNT(*)
FROM educator ed
LEFT JOIN person p ON ed.person_id = p.person_id
WHERE p.person_id IS NULL

UNION ALL

SELECT 
  'Consultants without educator record',
  COUNT(*)
FROM consultant co
LEFT JOIN educator ed ON co.person_id = ed.person_id
WHERE ed.person_id IS NULL;

-- Expected: 0 violations
-- Proves shared PK inheritance is correct

\echo ''

-- ========================================
-- Check 4: Business Rules
-- ========================================
\echo '====================================='
\echo 'Check 4: Business Rules'
\echo 'Purpose: Verify business logic constraints'
\echo '====================================='

-- 4a) Alla studenter har känslig data
SELECT 
  'Students without sensitive data' AS check_type,
  COUNT(*) AS violations
FROM student s
LEFT JOIN person_sensitive ps ON s.person_id = ps.person_id
WHERE ps.person_id IS NULL

UNION ALL

-- 4b) Alla program-klasser har program
SELECT 
  'Program classes without program_id',
  COUNT(*)
FROM class c
WHERE c.program_id IS NULL 
  AND c.class_code NOT LIKE 'FREE%'  -- Exkludera fristående

UNION ALL

-- 4c) Alla fristående klasser SAKNAR program
SELECT 
  'Standalone classes with program_id',
  COUNT(*)
FROM class c
WHERE c.program_id IS NOT NULL 
  AND c.class_code LIKE 'FREE%';

-- Expected: 0 violations
-- Proves business logic is enforced

\echo ''

-- ========================================
-- Check 5: Data Completeness
-- ========================================
\echo '====================================='
\echo 'Check 5: Data Completeness'
\echo 'Purpose: Verify minimum data exists for demo'
\echo '====================================='

SELECT 
  'Total facilities' AS metric,
  COUNT(*) AS count,
  CASE WHEN COUNT(*) >= 2 THEN 'OK' ELSE 'FAIL' END AS status
FROM facility

UNION ALL

SELECT 
  'Total programs',
  COUNT(*),
  CASE WHEN COUNT(*) >= 1 THEN 'OK' ELSE 'FAIL' END
FROM program

UNION ALL

SELECT 
  'Total courses',
  COUNT(*),
  CASE WHEN COUNT(*) >= 5 THEN 'OK' ELSE 'FAIL' END
FROM course

UNION ALL

SELECT 
  'Total students',
  COUNT(*),
  CASE WHEN COUNT(*) >= 2 THEN 'OK' ELSE 'FAIL' END
FROM student

UNION ALL

SELECT 
  'Total educators',
  COUNT(*),
  CASE WHEN COUNT(*) >= 2 THEN 'OK' ELSE 'FAIL' END
FROM educator

UNION ALL

SELECT 
  'Total teaching assignments',
  COUNT(*),
  CASE WHEN COUNT(*) >= 2 THEN 'OK' ELSE 'FAIL' END
FROM teaching_assignment;

-- Expected: All rows show - OK
-- Proves seed data is complete

\echo ''

-- ========================================
-- Check 6: BONUS Features Verification
-- ========================================
\echo '====================================='
\echo 'Check 6: BONUS Features'
\echo 'Purpose: Verify all BONUS requirements are implemented'
\echo '====================================='

-- 6a) Fast anställda educators (BONUS)
SELECT 
  'Fast anställda educators (BONUS)' AS feature,
  COUNT(*) AS count,
  CASE WHEN COUNT(*) >= 1 THEN 'IMPLEMENTED' ELSE 'MISSING' END AS status
FROM educator ed
JOIN employee emp ON ed.person_id = emp.person_id;

-- Expected: >= 1 (Eva är fast anställd educator)

\echo ''

-- 6b) Fristående kurser (BONUS)
SELECT 
  'Fristående kurser (BONUS)' AS feature,
  COUNT(*) AS count,
  CASE WHEN COUNT(*) >= 1 THEN 'IMPLEMENTED' ELSE 'MISSING' END AS status
FROM course cr
LEFT JOIN program_course pc ON cr.course_id = pc.course_id
WHERE pc.course_id IS NULL;

-- Expected: >= 1 (FREE01 exists)

\echo ''

-- 6c) Multi facility (BONUS )
SELECT 
  'Multi-facility expansion (BONUS)' AS feature,
  COUNT(DISTINCT city) AS num_cities,
  CASE WHEN COUNT(DISTINCT city) >= 2 THEN 'IMPLEMENTED' ELSE 'MISSING' END AS status
FROM facility;

-- Expected: >= 2 cities (Stockholm, Göteborg)

\echo ''
\echo '######################################'
\echo '# SANITY CHECKS COMPLETE            #'
\echo '######################################'