# LDM (Logical Data Model) – YrkesCo


## ERD:
## Roller (shared primary key)
- person(person_id) är en supertype.
- student.person_id = PK+FK --> person.person_id
- employee.person_id = PK+FK --> person.person_id
- educator.person_id = PK+FK --> person.person_id
- person_sensitive.person_id = PK+FK --> person.person_id
- consultant.person_id = PK+FK --> educator.person_id

## Nyckelrelationer
- student.class_id FK --> class.class_id (NOT NULL)
- class.facility_id FK --> facility.facility_id (NOT NULL)
- class.program_id FK --> program.program_id (NULLABLE för fristående klass)
- class.class_managed_by_employee_person_id FK --> employee.person_id (NOT NULL)
- program_course PK (program_id, course_id) med FK till program och course

## Teaching assignment (triangel)
- teaching_assignment.class_id FK --> class.class_id (NOT NULL)
- teaching_assignment.course_id FK --> course.course_id (NOT NULL)
- teaching_assignment.educator_person_id FK --> educator.person_id (NOT NULL)
- Constraint: UNIQUE(class_id, course_id, educator_person_id)

## Dokumentation:

## 1 - Mina designval: Person hierarkin (shared primary keys)  
För att kunna hantera dataintegriteten kring personer och roller så valde jag att använda mig av en **Supertype/subtype**struktur med delad primärnyckel (Shared PK)  

- Person (min **supertype**) innehåller grunddatan med namn, email som är gemensam för alla.  

- Roller (**subtypes**): `student`, `employee`, `educator` och `person_sensitive` ärver **DIREKT** från `person`.  

  - Lösning: Do här entiteterna(tabellerna) använder `person_id` som både Primary Key(PK) och Foreign Key(FK).  

  - Fördelen är detta: Det eliminerar behovet av redundanta ID kolumner som Surrogate Keys ger och garanterar en 1:1(one to one) relation. En **student** är EN **person**, en **employee** är EN **person** etc.  

- Arvskedjan: Konsulter hanteras som en förlängning av `educator`(utbildare) -> `consultant`. Det gör att YrkCo kan skilja på t.ex `employee` löner och `consultant` arvoden utan några NULL values.


## 2 - Beskrivningar om relationer:
- `class` En klass tillhör en specifik **facility**(anläggning) och en `class` har exakt en utbildningsledare som är en `employee`.  

- `program` och `course` Ett program består utav flera kurser och en kurs kan ingå i flera program. Det här löses med en junction table `program_course`.  

- `teaching_assignment` Det här är mittpunkten för schemaläggning. Entiteten(tabellen) kopplar samman `class`, `course` och `educator` för att definiera **vem** det är som undervisar **vad** och **var**.

## 3 - Normalisering (Mina argument för 1NF, 2NF och 3NF)
- Min modell uppfyller 3NF(Tredje normalformen) genom följande: 

  - 1NF (Atomicity - Atomära värden).  
  - Alla attributer t.ex `address`, `city` är uppdelade och innehåller endast **ett** värde per cell. Ingen upprepad data förekommer.  

  - 2NF (Partial Dependencies - Partiella beroenden).  
  - Alla entiteter(tabeller) har unika **primärnycklar(PKs)**.
  - I `program_course` som är en junction table är attributen `semester_number` fullt beroende av **hela** den sammansatta nyckeln och inte bara en **del** av den.  

  - 3NF (Transitive Dependencies - Transitiva beroenden).  
  - Min modell eliminerar transitiva beroenden genom följande design:  

    - **Exempel 1:** city och address finns i `FACILITY` inte i `CLASS`.  
      - **Varför?** `City` beror på `facility_id` inte `class_id`. Om jag hade `class.city` skulle det vara ett transitivt beroende `(class -> facility -> city)`  
    
    - **Exempel 2:** `employee_salary` finns i `EMPLOYEE` och inte i `PERSON`
      - **Varför?** `Salary` beror på `employment` och inte på att vara `person`. En `person` kan vara `student` (dvs, ingen `salary`) eller `consultant` och har då en `hourly_rate` istället.

    - **Exempel 3:** `hourly_rate` finns i `CONSULTANT` och inte i `EDUCATOR`
      - **Varför?** `hourly_rate` är specifikt för konsulter. Anställda (fast anställda, timanställda, vikarier etc) `educators` har `employee_salary` istället.  

  - Attributer som inte är nycklar är enbart beroende av **primärnyckeln(PK)**. T.ex `employee_salary` ligger i `employee` entiteten(tabellen) och är beroende av `employee`(anställningstabellen) och inte utav `person` entiteten(tabellen). `city` ligger i `facility` entiteten(tabellen) och inte i `class`. Den känsliga datan i databasen finns i `person_sensitive` entiteten(tabellen), detta fär att isolera beroendet och öka säkerheten av känslig data för att ej bryta mot **dataskyddsförordningen(GDPR)**. 
