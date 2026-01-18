# "Runbook" (playbook) for docker. My easy go to commands in mini-format.

## 1) Starta containern (om den inte redan är igång och kör
 `docker compose -f docker/docker-compose.yml --env-file docker/.env up -d`  

## 2) Kör din fil(01_ddl.sql, 02_seed.sql, 03_queries.sql etc)  
`docker exec -it lab_yrkesco_postgres psql -U <USERNAME> -d yrkesco_db -f /sql/02_seed.sql`  

## Snabb sanity check  
`docker exec -it lab_yrkesco_postgres psql -U <USERNAME> -d yrkesco_db -c "SELECT COUNT(*) FROM person;"` 

`docker exec -it lab_yrkesco_postgres psql -U <USERNAME> -d yrkesco_db -c "SELECT COUNT(*) FROM class;"`

## Kör queries (eller annan fil)
`docker exec -it lab_yrkesco_postgres psql -U <USERNAME> -d yrkesco_db -f /sql/03_queries.sql`