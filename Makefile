dbtproject_check = $(if $(DBT_PROJECT),,@echo "DBT_PROJECT variable is not set or empty"; exit 1)
modelname_check = $(if $(MODEL_NAME),,@echo "MODEL_NAME variable is not set or empty"; exit 1)
dbtcommand_check = $(if $(DBT_COMMAND),,@echo "DBT_COMMAND variable is not set or empty"; exit 1)

NETWORK_NAME = "dbt_examples"

create-env:
	mkdir -p postgres/app
	mkdir -p postgres/ini
	mkdir -p postgres/output
	mkdir -p secrets/.dbt
	chmod 777 -R postgres 2>/dev/null || true
	chmod 777 -R secrets 2>/dev/null || true
	docker network inspect $(NETWORK_NAME) >/dev/null 2>&1 || docker network create $(NETWORK_NAME)

dbt-init: create-env
	docker run -it \
	-v ${PWD}:/usr/app \
	-v ${PWD}/secrets/.dbt:/root/.dbt \
	-w /usr/app \
	xemuliam/dbt:latest dbt init

run-dbs: create-env
	docker compose -f docker-compose.yaml up -d postgres

stop-dbs:
	docker compose -f docker-compose.yaml down

run-psql:
	docker compose exec postgres psql -U myuser -d main

dbt: create-env clean-dbt
	$(call dbtproject_check)
	$(call dbtcommand_check)
#	$(call modelname_check)
	docker run -it \
	--network $(NETWORK_NAME) \
	--name dbt \
	-v ${PWD}/$(DBT_PROJECT):/usr/app \
	-v ${PWD}/secrets/.dbt:/root/.dbt \
	-w /usr/app \
	xemuliam/dbt \
	dbt --no-partial-parse $(DBT_COMMAND)
#	--models $(MODEL_NAME)

clean-dbt:
	docker rm -f dbt

clean:
	docker ps -aq | xargs -I {} docker rm -f {}

.PHONY: create-env \
	clean \
	run-dbs \
	stop-dbs \
	run-psql \
	clean-dbt \
	dbt \
	dbt-init