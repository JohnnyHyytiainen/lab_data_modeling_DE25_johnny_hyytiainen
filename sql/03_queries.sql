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


-- 2) Utbildare och om de är konsult + företag
-- INNER + LEFT JOIN
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