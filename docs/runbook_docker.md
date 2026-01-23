# "Runbook" (playbook) for docker. My easy go to commands in mini-format.
This document serves as a quick reference guide for managing the Docker environment and interacting with the PostgreSQL database. *(See output.md for more extensive command docs regarding this lab)*

## 0) Panic Button (Nuke & Reset)
- Use this only if you need to completely wipe the database and start fresh (ex, after a failed experiment).  
**WARNING: This deletes all data volumes!**   

- `docker compose -f docker/docker-compose.yml --env-file docker/.env down -v`


## 1) Lifecycle management:
- Basic commands to control the stack.  
**Start the environment (Create and build):**
  - `docker compose -f docker/docker-compose.yml --env-file docker/.env up -d`

- Check status. Is it running?:
  - `docker compose -f docker/docker-compose.yml --env-file docker/.env ps`
- View logs (debug errors):
  - `docker logs -f lab_yrkesco_postgres`
- Stop the environment:
  - `docker compose -f docker/docker-compose.yml --env-file docker/.env down`
- Resume a stopped container (without rebuilding!):
  - `docker start lab_yrkesco_postgres`

## To avoid Git Bash headaches(bypass path issues):
- `docker exec -it lab_yrkesco_postgres bash -lc "psql -U <USERNAME> -d yrkesco_db -f /sql/02_seed.sql"`

- **OR** if you'd like to enter the container manually and run:
  - `docker exec -it lab_yrkesco_postgres bash`  
  - `psql -U <USERNAME> -d yrkesco_db -f /sql/02_seed.sql`

**"Just because you're paranoid, it doesn't mean they(the bugs) aren't after you"**  - Joseph Heller

