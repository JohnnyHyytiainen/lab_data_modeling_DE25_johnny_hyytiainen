-- Failsafe, FAIL FAST. 
-- Kill everything at first issue (works well with DROP TABLE IF EXISTS .... CASCADE)
-- NOTE: Be sure to NOT use DROP TABLE .... with this command. Be sure to use DROP TABLE IF EXISTS.
\set ON_ERROR_STOP on

BEGIN;

-- Facilities (2 st, bonus fler senare = bara fler rows)
INSERT INTO facility (name, city, postal_code, address, capacity, room_type, hc_accessible)
SELECT 'YrkesCo Göteborg', 'Göteborg', '411 00', 'Avenyn 1', 200, 'Campus', TRUE
WHERE NOT EXISTS (SELECT 1 FROM facility WHERE name='YrkesCo Göteborg' AND city='Göteborg');

INSERT INTO facility (name, city, postal_code, address, capacity, room_type, hc_accessible)
SELECT 'YrkesCo Stockholm', 'Stockholm', '111 20', 'Sveavägen 2', 250, 'Campus', TRUE
WHERE NOT EXISTS (SELECT 1 FROM facility WHERE name='YrkesCo Stockholm' AND city='Stockholm');


-- Program (1 program, 3 klasser = 3 omgångar)
INSERT INTO program (program_id, program_code, program_name, points_total, decision_number)
VALUES ('DE25', 'DE25', 'Data Engineer', 400, 1)
ON CONFLICT (program_code) DO NOTHING;

INSERT INTO program (program_id, program_code, program_name, points_total, decision_number)
VALUES ('UX25', 'UX25', 'UX Designer', 400, 1)
ON CONFLICT (program_code) DO NOTHING;


-- Courses (inkl fristående bonus = kurs som inte hamnar i program_course)
INSERT INTO course (course_id, course_code, course_name, course_description, course_points)
VALUES
  ('SQL101','SQL101','SQL Basics','Joins, group by, constraints',50),
  ('DM101','DM101','Data Modeling','CDM/LDM/PDM',50),
  ('ETL101','ETL101','ETL Pipelines','Extract, Transform, Load processes',50),
  ('PY101','PY101','Python Programming','Introduction to Python',50),
  ('LIA','LIA','Internship','Practical work experience',150),
  ('FREE01','FREE01','Fristående kurs','Standalone course',25)
ON CONFLICT (course_code) DO NOTHING;


-- Program_course (FREE01 kopplas inte -> fristående)
INSERT INTO program_course (program_id, course_id, semester_number)
VALUES
  ('DE25', 'SQL101', 1),
  ('DE25', 'DM101',  2),
  ('DE25', 'ETL101', 1),
  ('DE25', 'PY101', 2),
  ('DE25', 'LIA', 2)
ON CONFLICT (program_id, course_id) DO NOTHING;

-- People
-- Employee (utbildningsledare/admin) ska kunna hantera 3 klasser
INSERT INTO person (first_name, last_name, email)
VALUES ('Alex', 'Admin', 'alex.admin@yrkesco.se')
ON CONFLICT (email) DO NOTHING;

INSERT INTO employee (person_id, title, employee_nr, employee_salary, employment_type)
SELECT person_id, 'Utbildningsledare', 'EMP-0001', 42000, 'tillsvidare'
FROM person
WHERE email = 'alex.admin@yrkesco.se'
ON CONFLICT (employee_nr) DO NOTHING;

-- Educator (fast anställd lärare) + Consultant educator
INSERT INTO person (first_name, last_name, email)
VALUES ('Eva', 'Educator', 'eva.educator@yrkesco.se')
ON CONFLICT (email) DO NOTHING;

INSERT INTO educator (person_id, competence_area)
SELECT person_id, 'Data Modeling'
FROM person
WHERE email = 'eva.educator@yrkesco.se'
ON CONFLICT (person_id) DO NOTHING;

-- Eva = (fast anställd lärare) (educator + employee)
INSERT INTO employee (person_id, title, employee_nr, employee_salary, employment_type)
SELECT p.person_id, 'Utbildare', 'EMP-0002', 45000, 'tillsvidare'
FROM person p
WHERE p.email = 'eva.educator@yrkesco.se'
ON CONFLICT (person_id) DO NOTHING;

INSERT INTO person (first_name, last_name, email)
VALUES ('Conny', 'Consultant', 'conny.consultant@external.se')
ON CONFLICT (email) DO NOTHING;

INSERT INTO educator (person_id, competence_area)
SELECT person_id, 'SQL'
FROM person
WHERE email = 'conny.consultant@external.se'
ON CONFLICT (person_id) DO NOTHING;

INSERT INTO consultant_company (org_number, name, has_f_skatt, address)
VALUES ('556677-8899', 'ConsultCo AB', TRUE, 'Konsultgatan 3')
ON CONFLICT (org_number) DO NOTHING;

INSERT INTO consultant (person_id, consultant_company_id, hourly_rate)
SELECT p.person_id, cc.consultant_company_id, 1200
FROM person p
JOIN consultant_company cc ON cc.org_number = '556677-8899'
WHERE p.email = 'conny.consultant@external.se'
ON CONFLICT (person_id) DO NOTHING;

-- Classes: 3 för programmet + 1 fristående (program_id NULL)
INSERT INTO class (class_code, facility_id, program_id, managed_by_employee_person_id, cohort_number, start_date, end_date, is_distance)
SELECT
  'DE25-01', f.facility_id, 'DE25', e.person_id, 1, DATE '2026-01-15', NULL, FALSE
FROM facility f, employee e
WHERE f.city='Stockholm' AND e.employee_nr='EMP-0001'
ON CONFLICT (class_code) DO NOTHING;

INSERT INTO class (class_code, facility_id, program_id, managed_by_employee_person_id, cohort_number, start_date, end_date, is_distance)
SELECT
  'DE25-02', f.facility_id, 'DE25', e.person_id, 2, DATE '2026-08-15', NULL, TRUE
FROM facility f, employee e
WHERE f.city='Göteborg' AND e.employee_nr='EMP-0001'
ON CONFLICT (class_code) DO NOTHING;

INSERT INTO class (class_code, facility_id, program_id, managed_by_employee_person_id, cohort_number, start_date, end_date, is_distance)
SELECT
  'DE25-03', f.facility_id, 'DE25', e.person_id, 3, DATE '2027-01-15', NULL, FALSE
FROM facility f, employee e
WHERE f.city='Stockholm' AND e.employee_nr='EMP-0001'
ON CONFLICT (class_code) DO NOTHING;

-- Fristående klass (bonus)
INSERT INTO class (class_code, facility_id, program_id, managed_by_employee_person_id, cohort_number, start_date, end_date, is_distance)
SELECT
  'FREE-01', f.facility_id, NULL, e.person_id, NULL, DATE '2026-03-01', NULL, FALSE
FROM facility f, employee e
WHERE f.city='Göteborg' AND e.employee_nr='EMP-0001'
ON CONFLICT (class_code) DO NOTHING;

-- Students + sensitive info
INSERT INTO person (first_name, last_name, email)
VALUES
  ('Sara', 'Student', 'sara.student@yrkesco.se'),
  ('Nils', 'Student', 'nils.student@yrkesco.se')
ON CONFLICT (email) DO NOTHING;

INSERT INTO person_sensitive (person_id, personal_number, private_email, home_address, phone_number)
SELECT person_id, '19900101-1234', 'sara.private@mail.com', 'Studentvägen 1', '0701112233'
FROM person WHERE email='sara.student@yrkesco.se'
ON CONFLICT (personal_number) DO NOTHING;

INSERT INTO person_sensitive (person_id, personal_number, private_email, home_address, phone_number)
SELECT person_id, '19920202-5678', 'nils.private@mail.com', 'Studentvägen 2', '0709998877'
FROM person WHERE email='nils.student@yrkesco.se'
ON CONFLICT (personal_number) DO NOTHING;

-- Place students into classes
INSERT INTO student (person_id, class_id)
SELECT p.person_id, c.class_id
FROM person p
JOIN class c ON c.class_code='DE25-01'
WHERE p.email='sara.student@yrkesco.se'
ON CONFLICT (person_id) DO NOTHING;

INSERT INTO student (person_id, class_id)
SELECT p.person_id, c.class_id
FROM person p
JOIN class c ON c.class_code='FREE-01'
WHERE p.email='nils.student@yrkesco.se'
ON CONFLICT (person_id) DO NOTHING;

-- Teaching assignments (ternary)
-- DE25-01 gets SQL101 taught by Conny (consultant educator)
INSERT INTO teaching_assignment (class_id, course_id, educator_person_id, start_date, end_date, term)
SELECT c.class_id, 'SQL101', e.person_id, DATE '2026-01-20', NULL, 'VT'
FROM class c
JOIN educator e ON e.person_id = (SELECT person_id FROM person WHERE email='conny.consultant@external.se')
WHERE c.class_code='DE25-01'
ON CONFLICT (class_id, course_id, educator_person_id) DO NOTHING;

-- FREE-01 gets FREE01 taught by Eva (employee educator)
INSERT INTO teaching_assignment (class_id, course_id, educator_person_id, start_date, end_date, term)
SELECT c.class_id, 'FREE01', e.person_id, DATE '2026-03-05', NULL, 'VT'
FROM class c
JOIN educator e ON e.person_id = (SELECT person_id FROM person WHERE email='eva.educator@yrkesco.se')
WHERE c.class_code='FREE-01'
ON CONFLICT (class_id, course_id, educator_person_id) DO NOTHING;

COMMIT;
