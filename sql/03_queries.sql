-- ==========================================
-- Q-1A. Student overview. Students + Class + Program + location(ort)
-- JOIN(INNER) + LEFT JOIN + ORDER BY(Sorting)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 1A: Student roster, Class, Program and Location including program classes and stand alone classes'
\echo 'Purpose: Retrieving all students with their class, program, and campus city'
\echo '================================='
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

-- ==========================================
-- Q-1B. Student overview. Student + Class + Program + Location(ort) filtered by Class Code DE25-01
-- JOIN(INNER) + WHERE(Filtering)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 1B: Student roster, Program, Class and city'
\echo 'Purpose: Retrieving all students with their class tied to a specific program and which campus'
\echo '================================='
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


-- ==========================================
-- Q-2A. Educator, Consultant and Company query (POSTGRESQL SPECIFIC variant) 
-- JOIN(INNER) + LEFT JOIN
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 2A: Educator status (Consultants + Employees)'
\echo 'Purpose: Identifying consultants using Boolean logic (IS NOT NULL, POSTGRESQL SPECIFIC variant)'
\echo '================================='
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

-- ==========================================
-- Q-2B. Educator, Consultant and Company query (STANDARD SQL variant using CASE WHEN .... ELSE.... END)
-- JOIN(INNER) + LEFT JOIN + Sorting(ORDER BY)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 2B: Educator status (Consultants + Employees)'
\echo 'Purpose: Identifying consultants using Boolean logic (CASE WHEN..ELSE..END.. STANDARD SQL variant)'
\echo '================================='

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

-- ==========================================
-- Q-3. Progran(program code), Semester nr, Course related query(prog_code, sem_nr, course_code/name/points)
-- JOIN(INNER) + Sorting(ORDER BY)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 3: Program status (Program code, Semester nr, Course code, name and points'
\echo 'Purpose: Identifying relevant Course information tied to a Program'
\echo '================================='
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

-- ==========================================
-- Q-4. Stand alone courses(Fristående kurser) not part of any program.
-- LEFT JOIN + Searching for NULL VALUE(NULL value = not tied to specific program) + Sorting(ORDER BY)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 4: Standalone Courses(Freestanding Courses)'
\echo 'Purpose: Identifying courses not tied to a specific Program. (NULL VALUE == Standalone Course)'
\echo '================================='
SELECT cr.course_code, 
cr.course_name
FROM course cr
LEFT JOIN program_course pc ON pc.course_id = cr.course_id
WHERE pc.course_id IS NULL
ORDER BY cr.course_code;

-- ==========================================
-- Q-5A Searching for Employee Class administrators and what programs + classes they are admins for.
-- JOIN(INNER) + GROUPING + Sorting(ORDER BY)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 5A: Class Administrator TOTAL workload'
\echo 'Purpose: Identifying number of TOTAL CLASSES managed by a Class admin'
\echo '================================='
\echo 'Business ambiguity identified. Requirements did not specify LIMIT to numbers of classes managed by admin'
\echo 'Recommendation: Review wording in business requirements to not overload Class admins with too much work!'
\echo '================================='
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

-- ==========================================
-- Q-5B Searching for Employee Class administrators to see how many CLASSES they are administrators for.
-- JOIN(INNER) + Grouping(GROUP BY), Counting(HAVING COUNT), Ordering(ORDER BY)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 5B: Class Administrator TOTAL workload'
\echo 'Purpose: Identifying number of TOTAL CLASSES managed by a Class admin'
\echo '================================='
\echo 'Alex is currently managing 3 Programs and 1 Standalone Course'
\echo 'Recommendation: See prior recommendation for business requirements ambiguity'
\echo '================================='
SELECT
  p.first_name, p.last_name, emp.employee_nr,
  COUNT(*) AS classes_managed
FROM class c
JOIN employee emp ON emp.person_id = c.managed_by_employee_person_id
JOIN person p ON p.person_id = emp.person_id
GROUP BY p.first_name, p.last_name, emp.employee_nr
HAVING COUNT(*) >= 3
ORDER BY classes_managed DESC, emp.employee_nr;

-- ==========================================
-- Q-5C Searching for how many SPECIFIC PROGRAMS one Employee is a Class Administrator for. Ignoring Stand alone courses
-- JOIN(INNER) + Ignoring NULL VALUES(stand alone = NULL) + WHERE(Filtering) + GROUP BY(Sorting)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 5C: Class Administrator TOTAL Program workload'
\echo 'Purpose: Identifying total nr of PROGRAMS Administered by Class Admin'
\echo 'Alex is currently Administrating the MAXIMUM number of Programs.'
\echo '================================='
SELECT
  p.first_name, p.last_name, emp.employee_nr,
  COUNT(*) AS program_classes_managed
FROM class c
JOIN employee emp ON emp.person_id = c.managed_by_employee_person_id
JOIN person p ON p.person_id = emp.person_id
WHERE c.program_id IS NOT NULL
GROUP BY p.first_name, p.last_name, emp.employee_nr
HAVING COUNT(*) = 3;

-- ==========================================
-- Q-6A Searching for teaching assignments per class. Which Educator(teacher) teaches What Courses
-- JOIN(INNER) + ORDER BY(Sorting)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 6A: Teaching Assignments'
\echo 'Purpose: Linking the Class, Course and Program to When'
\echo '================================='
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

-- ==========================================
-- Q-6B Searching for Teaching Assignments. Which class and how many courses
-- JOIN(INNER) + GROUP BY, ORDER BY(Sorting)
-- ==========================================
\echo ''
\echo '================================='
\echo 'Query 6B: Teachin Assignments'
\echo 'Purpose: Linking number of Courses a Specific Program or Class has.'
\echo '================================='
SELECT 
  c.class_code, 
  COUNT(DISTINCT ta.course_id) AS num_courses
FROM 
  teaching_assignment ta
JOIN class c ON c.class_id = ta.class_id
GROUP BY c.class_code
ORDER BY c.class_code;