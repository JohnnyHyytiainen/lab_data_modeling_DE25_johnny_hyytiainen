# Relationship statements conceptual entity diagram.

- **Class–Facility:**  
`En klass hör till exakt en anläggning. En anläggning kan husera noll eller flera klasser.`

- **Class–Student:**   
`En klass har en eller flera studenter. En student tillhör exakt en klass.`

- **Program–Course:**   
`Ett program innehåller en eller flera kurser. En kurs kan ingå i noll eller flera program (fristående kurs = 0 program)`

- **Program–Class:**  
`Ett program kan ha noll eller flera klasser. En klass tillhör noll eller ett program (Detta för att stödja fristående klasser utan program)`

- **TeachingAssignment: (Class–Course–Educator)**  
`Ett undervisningstillfälle kopplar exakt en klass, exakt en kurs och exakt en utbildare. En klass/kurs/utbildare kan ha noll eller flera undervisningstillfällen.`

- **Educator–Consultant:**   
`En konsult är alltid en utbildare. En utbildare kan vara anställd eller konsult.`

- **Consultant_Company–Consultant:**  
`Ett konsultföretag kan ha noll eller flera konsulter. En konsult tillhör exakt ett konsultföretag.`

- **Person–PersonSensitive:**  
`En person kan ha noll eller en post med känsliga uppgifter (t.ex personnummer). Känsliga uppgifter hör till exakt en person.`

- **Person–roller:**  
`Student/Employee/Educator är roller av Person, varje roll hör till exakt en person, men en person kan ha noll eller en av respektive roll.`