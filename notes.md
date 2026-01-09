# General notes for the data mod lab.

## BR's (Business rules)
- 3 rules + 1 key query

  - BR: ... ... ... ... 
  - Enforcement: (UNIQUE / NOT NULL+FK / CHECK / verifierings query)

- `En regel. Utöver "utbildningsledare har hand om 3 klasser" kan UL även vara UL för fristående kurser. (Sätt en max cap på 5st totalt, 2 klasser och 3 fristående kurser eller 1 fristående kurs och 4 klasser. MAX CAP på 5st totalt)`

- ` "Ett program blir beviljat i tre omgångar, dvs att det finns 3 klasser" Det vill säga ett program blir beviljat i tre omgångar där 1 omgång är t.ex 2025, omgång 2 är 2026 och omgång 3 är 2026. `

- "ett program blir beviljat i tre omgångar, dvs att det finns 3 klasser" `Det som EJ får ändras är namnet på programmet och slutpoängen på programmet. Dock så kan t.ex DE24 programmet ha DATA_MOD kursen med 30 poäng medan DE25 har 25 poäng. Dock så har DE25 5 poäng mer i kursen 'programmering' än vad DE24 hade`

- `Data engineer programmet, DE23, DE24, DE25(?) (använd en surrogate key som PK för program_id(?))`

- Olika konsulter kan ha olika arvoden. Tänk på att ha med det, arvodet som konsultbolaget fautkrerar Yrkesco företaget varierar beroende på vilken konsult

- `den CDM ska vara överblick på 'det stora hela', inget behov för junction tables/bridge tables. N:M tillåts i CDM. LDM -> PDM == junction/bridge tables`

- `Kom ihåg att lägga till relationship statements i CDM för var entitet (PÅ ENGELSKA!)`

- `Kom IHÅG att ha docker-compose.yml sparad i repot för att lärare ska kunna replikera containern!`
