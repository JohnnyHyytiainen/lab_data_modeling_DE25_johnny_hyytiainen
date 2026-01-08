# Bygga en databas för yrkeshögskolan YrkesCo

## Syfte
```
Syftet med denna labb är att applicera dina kunskaper inom datamodellering för att designa en databas åt en yrkeshögskola. 

Arbetet kommer därefter presenteras i form av en video pitch för att öva på plocka ut det viktigaste och kommunicera till en business.
``` 

## Bakgrund
```
Ni läser i en yrkeshögskola YrkesCo och många yrkeshögskolor jobbar med många excelfiler för att tracka olika saker såsom studenter, utbildare, utbildningsledare, anställda, kurser, program, konsulter mm. 

Det är inte ovanligt att en yh-anordnare också är uppdelad till flera enheter i flera orter i Sverige. 

Det är inte ovanligt att många anställda sitter med samma excelfiler och/eller egna excelfiler för att hålla koll på sina
arbetsområden/utbildningar. I kombination med excelfilerna finns också viss information i lärplattformar.
``` 

## Kravspecifikation
YrkesCo har identifierat att de vill ha en databas som har information

- om studenter, förnamn, efternamn, personnummer, email.  

- utbildare kan vara konsulter.

- de planerar att anställa fasta utbildare (BONUS).

- utbildningsledare och deras personuppgifter. 

- utbildningsledare har hand om 3 klasser.

- kurser med namn, kurskod, antal poäng, kort beskrivning av kursen.

- program har ett antal kurser knutna till sig.

- ett program blir beviljat i tre omgångar, dvs att det finns 3 klasser.

- det finns även fristående kurser (BONUS).

- konsulter, deras företag, företagsinfo som organisationsnummer, har F-skatt, address, hur mycket de
tar i arvode per timma.

- YrkesCo har två anläggningar, en i göteborg och en i stockholm, i framtiden kanske de kommer expandera till flera orter (BONUS).

```
Känsliga personuppgifter bör läggas i egna entiteter, eftersom det blir lättare att kontrollera vem som får access till dem tabellerna.

Är det några extra krav ni känner behövs, men YrkesCo missat att skriva ned, kan ni lägga till det, men behöver framgå vilka krav ni vill lägga till. Likaså om det är något krav som ni känner kan förtydligas, så kan ni också skriva till det.
```

## Uppgift 0 - datamodellering
```
a) Skapa ett folder i ditt repo som du kallar för yh_labb.

b) Gör en konceptuell modell baserat på kravspecifikationen.

c) Skriv relationship statements för varje entitet.

d) Bygg nu en logisk modell baserat på den konceptuella.

e) Skapa fysisk modell baserat på den logiska modellen.

f) Argumentera för att modellen du skapar uppnår 3 NF.
```

## Uppgift 1 - implementation

Implementera din fysiska modell i postgres. Alla SQL script ska finnas i din labbfolder. För implementation
ska du

```
a) skapa tabellerna

b) fylla i med fakedata (räcker med ett par records i varje tabell)

c) Gör ett/flera skript med SQL queries där du testar att joina olika tabeller för att plocka ut information. Ex kan du ta reda på en specifik klass vilken utbildningsledare den har, vilka kurser den har, hur många kurser, vilka utbildare som undervisar vilka kurser där.
```

## Uppgift 2 - presentation
```
Gör en presentation där du lägger in din datamodelleringen och beskriver varje steg. Tänk på att strukturera upp presentationen så att man får med det övergripande först och därefter gå mer in på tekniska detaljerna. 

Spara ned presentationen i pdf och ladda upp den till ditt repo i en labbfolder.
```

## Uppgift 3 - videopitch
```
Skapa en videopitch på 10-15 min där du delar skärm och presenterar det du kommit fram till. Gör även en
kort demo där du visar din implementation med tabellerna och datan.

Tänk på storytelling till business, men även tekniskt till utvecklare så att YrkesCo kan sälja in detta till deras
IT-team. Använd korrekt terminologi inom datamodellering.

Videopitchen kan med fördel göras på teams där du spelar in dig själv. På så sätt får du en länk som du kan
skicka in. Spelar du in i ett annat verktyg så kan du ladda upp videon på onedrive och därefter dela länk till
den.
```

## Skicka in
- Skicka in länken till videopresentationen, githubrepo med presentation i pdf och SQL kod som finns i repot.

## Godkänt
- gjort uppgifterna korrekt
- har grundläggande datamodell som reflekterar business requirements
- har fungerande implementation
## Väl godkänt
- labben är utfört på tillräcklig hög nivå med datamodell som reflekterar business requirements väl
- implementerat alla requirements inklusive de markerade med BONUS
- har använt sig av korrekt terminologi inom datamodelleringen