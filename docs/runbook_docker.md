# "Runbook" (playbook) for docker. My easy go to commands in mini-format.

## 1) Starta containern (om den inte redan är igång och kör
- `docker compose -f docker/docker-compose.yml --env-file docker/.env up -d`  

## 2) Kör din fil(01_ddl.sql, 02_seed.sql, 03_queries.sql etc)  
- `docker exec -it lab_yrkesco_postgres psql -U <USERNAME> -d yrkesco_db -f /sql/02_seed.sql`  

**För att BYPASSA Git Bash path issues**  
- `docker exec -it lab_yrkesco_postgres bash -lc "psql -U <USERNAME> -d yrkesco_db -f /sql/02_seed.sql"`

**Alternativt om du vill gå in manuellt i containern och köra**  
- `docker exec -it lab_yrkesco_postgres bash`  

- `psql -U <USERNAME> -d yrkesco_db -f /sql/02_seed.sql`



## Snabb sanity check  
- `docker exec -it lab_yrkesco_postgres psql -U <USERNAME> -d yrkesco_db -c "SELECT COUNT(*) AS persons FROM person;"` 

- `docker exec -it lab_yrkesco_postgres psql -U <USERNAME> -d yrkesco_db -c "SELECT COUNT(*) AS classes FROM class;"`  

- `docker exec -it lab_yrkesco_postgres psql -U <USERNAME> -d yrkesco_db -c "SELECT COUNT(*) AS ta FROM teaching_assignment;"`


## Kör queries (eller annan fil)
- `docker exec -it lab_yrkesco_postgres psql -U <USERNAME> -d yrkesco_db -f /sql/03_queries.sql`

