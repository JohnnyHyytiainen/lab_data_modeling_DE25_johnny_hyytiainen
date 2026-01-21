# First draft of my entities for this lab:

CORE ENTITIES

1)STUDENT
förnamn, efternamn, personnummer, email


2) UTBILDARE (kan vara konsult ELLER fast anställd)
personnummer? namn? email?
Relation till KONSULT (om extern)


3) KONSULT
namn (eller koppling till UTBILDARE?)
företag, org.nr, F-skatt status
address
arvode per timme


4) UTBILDNINGSLEDARE
förnamn, efternamn, email, personnummer?
Ansvarig för 3 klasser


5) KURS
kursnamn
kurskod (unique?)
antal poäng
beskrivning


6) PROGRAM
programnamn
koppling till kurser (N:M -> junction table!)
beviljat i 3 omgångar (dvs 3 klasser per program)


7) KLASS (cohort/omgång)
klass_id
program_id (FK)
utbildningsledare_id (FK)
start_date, end_date?
anläggning_id (FK -> Stockholm eller Göteborg)


8) ANLÄGGNING (facility/campus)
anläggning_id
stad (Stockholm, Göteborg, [framtida orter])
address



BONUS ENTITIES:

9) FAST UTBILDARE (distinction från konsulter)
anställningsdatum
lön (vs konsult's arvode per timme)
Relation till UTBILDARE


10) FRISTÅENDE KURSER (kurser INTE knutna till program)
Samma som KURS, men ingen koppling till PROGRAM
Egen KLASS för fristående kurser?

-----------------------------------------------------------------------
Entities:

[STUDENT]
[UTBILDARE]
[KONSULT]
[UTBILDNINGSLEDARE]
[KURS]
[PROGRAM]
[KLASS]
[ANLÄGGNING]
[ANSTÄLLD]
[UTBILDAR]