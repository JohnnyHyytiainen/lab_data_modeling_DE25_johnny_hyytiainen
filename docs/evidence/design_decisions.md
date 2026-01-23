# Design Decisions & Logical Data Model

## 1. Hierarchy Strategy: Super/Subtype pattern
To ensure data integrity regarding persons and roles, I implemented a **Supertype/Subtype** structure with Shared Primary Keys.

* **Supertype:** `Person` contains the foundational data (name, email, phone) common to everyone that is a person.

* **Subtypes:** `Student`, `Employee`, `Educator` and `Person_Sensitive` inherit directly from `Person`.

* **Implementation:** These tables use `person_id` as both Primary Key (PK) and Foreign Key (FK).

* **Benefit:** This eliminates redundant ID columns (Surrogate Keys) and enforces a strict 1:1 relationship. A student **is** a person.


## 2. Key Relationships: 

* **Class Assignment:** A class belongs to a specific `Facility` and has exactly one education leader (`Employee`)

* **Programs & Courses:** A program consists of multiple courses, and a course can be part of multiple programs. This is resolved via the junction table `program_course`.  

* **Teaching Assignments:** The central scheduling entity. It connects `Class`, `Course` and `Educator` to define **who** teaches **what** and **where.**

## 3. Normalization Compliance (3NF)  

My model achieves the Third Normal Form (3NF) through the following design choices:

* **1NF (Atomicity):** All attributes (ex, address components) are atomic. No repeating groups.

* **2NF (Partial Dependencies):** All tables have unique PKs. In junction tables like `program_course`, attributes depend on the **entire** composite key.

* **3NF (Transitive Dependencies):**

    * **Location:** `City` and `Address` are located in `Facility` and not in `Class`. `City` depends on the facility, not the class ID.

    * **Salaries:** `Employee_salary` exists in `Employee`, not `Person`. A person can be a student (no salary) or a consultant (hourly rate).

    * **GDPR:** Sensitive data is isolated in `Person_Sensitive` to separate dependency and increase security and to comply with rules and regulations.

## 4. Business Rules:

* **Student-Class Assignment:** `student.class_id` is set to **NOT NULL**. YrkesCo only registers students once a class is confirmed. Applicants without a class remain in the `Person` table until admitted.