-- 1) Studenter + klass + program + ort
-- INNER + LEFT JOIN
SELECT
  p.first_name, p.last_name, p.email,
  c.class_code,
  pr.program_name,
  f.city
FROM student s
JOIN person p ON p.person_id = s.person_id
JOIN class c ON c.class_id = s.class_id
JOIN facility f ON f.facility_id = c.facility_id
LEFT JOIN program pr ON pr.program_id = c.program_id
ORDER BY c.class_code, p.last_name;

-- 1.5) Studenter + klass + program + ort med enbart DE25-01 som klasskod
SELECT
  p.first_name, p.last_name, p.email,
  c.class_code,
  pr.program_name,
  f.city
FROM student s
JOIN person p ON p.person_id = s.person_id
JOIN class c ON c.class_id = s.class_id
JOIN facility f ON f.facility_id = c.facility_id
LEFT JOIN program pr ON pr.program_id = c.program_id
WHERE c.class_code = 'DE25-01'
ORDER BY c.class_code, p.last_name;


-- 2) Utbildare och om de är konsult + företag (POSTGRESQL variant)
-- INNER + LEFT JOIN
\echo '----- Query 2) Educators + consultant status (IS NOT NULL) -----'
SELECT
  p.first_name, p.last_name, e.competence_area,
  (co.person_id IS NOT NULL) AS is_consultant,
  cc.name AS consultant_company,
  co.hourly_rate
FROM educator e
JOIN person p ON p.person_id = e.person_id
LEFT JOIN consultant co ON co.person_id = e.person_id
LEFT JOIN consultant_company cc ON cc.consultant_company_id = co.consultant_company_id
ORDER BY is_consultant DESC, p.last_name;

-- 2.5) Utbildare och om de är konsult + företag (Standard SQL CASE WHEN .... ELSE .... END variant)
-- INNER + LEFT JOIN
\echo '----- Query 2.5) Educators + consultant status (CASE WHEN) -----'
SELECT
  p.first_name,
  p.last_name,
  e.competence_area,
  CASE
    WHEN co.person_id IS NOT NULL THEN TRUE
    ELSE FALSE
  END AS is_consultant,
  cc.name AS consultant_company,
  co.hourly_rate
FROM educator e
JOIN person p ON p.person_id = e.person_id
LEFT JOIN consultant co ON co.person_id = e.person_id
LEFT JOIN consultant_company cc ON cc.consultant_company_id = co.consultant_company_id
ORDER BY is_consultant DESC, p.last_name;

-- 3) Program → kurser (termin)
-- INNER JOIN
SELECT
  pr.program_code,
  pc.semester_number,
  cr.course_code,
  cr.course_name,
  cr.course_points
FROM program_course pc
JOIN program pr ON pr.program_id = pc.program_id
JOIN course cr ON cr.course_id = pc.course_id
ORDER BY pr.program_code, pc.semester_number;

-- 4) Fristående kurser (kurser som inte ingår i något program)
-- LEFT JOIN
SELECT cr.course_code, 
cr.course_name
FROM course cr
LEFT JOIN program_course pc ON pc.course_id = cr.course_id
WHERE pc.course_id IS NULL
ORDER BY cr.course_code;


-- 5) Utb ledare/klass admin har hand om klasser (visar admins klasser)
-- INNER JOIN
SELECT
  p.first_name, 
  p.last_name, 
  emp.employee_nr,
  COUNT(*) AS classes_managed
FROM class c
JOIN employee emp ON emp.person_id = c.managed_by_employee_person_id
JOIN person p ON p.person_id = emp.person_id
GROUP BY p.first_name, p.last_name, emp.employee_nr
ORDER BY classes_managed DESC, emp.employee_nr;

-- 5.5) Utb ledare/klass admin har hand om 3 klasser (räkna klasser per admin)
-- NOTE i seed datan har Alex hand om 4 klasser(inklusive fristående FREE-01)
\echo '----- Query 5.5) Alex is class manager for 3 PROGRAMS and 1 Standalone course. -----'
SELECT
  p.first_name, p.last_name, emp.employee_nr,
  COUNT(*) AS classes_managed
FROM class c
JOIN employee emp ON emp.person_id = c.managed_by_employee_person_id
JOIN person p ON p.person_id = emp.person_id
GROUP BY p.first_name, p.last_name, emp.employee_nr
HAVING COUNT(*) >= 3
ORDER BY classes_managed DESC, emp.employee_nr;

-- 5.6) Utb ledare/klass admin för PROGRAM klasser (ignorera fristående kurser)
\echo '----- Query 5.6) query to ONLY show PROGRAM admins. -----'
SELECT
  p.first_name, p.last_name, emp.employee_nr,
  COUNT(*) AS program_classes_managed
FROM class c
JOIN employee emp ON emp.person_id = c.managed_by_employee_person_id
JOIN person p ON p.person_id = emp.person_id
WHERE c.program_id IS NOT NULL
GROUP BY p.first_name, p.last_name, emp.employee_nr
HAVING COUNT(*) = 3;


-- 6) Teaching assignments(undervisningstillfällen) per klass. Vilka utbildare undervisar vilka kurser
-- INNER JOIN
SELECT
  c.class_code,
  cr.course_code,
  cr.course_name,
  p.first_name || ' ' || p.last_name AS educator_name,
  ta.term,
  ta.start_date
FROM teaching_assignment ta
JOIN class c ON c.class_id = ta.class_id
JOIN course cr ON cr.course_id = ta.course_id
JOIN person p ON p.person_id = ta.educator_person_id
ORDER BY c.class_code, ta.start_date;


-- 6.5) Teaching assignments(undervisningstillfällen). Antal kurser
SELECT 
  c.class_code, 
  COUNT(DISTINCT ta.course_id) AS num_courses
FROM 
  teaching_assignment ta
JOIN class c ON c.class_id = ta.class_id
GROUP BY c.class_code
ORDER BY c.class_code;