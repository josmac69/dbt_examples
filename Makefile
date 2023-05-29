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

dbt-run: create-env
	docker run -it \
	--network $(NETWORK_NAME) \
	--name dbt \
	-v ${PWD}/$(MODEL_NAME):/usr/app \
	-v ${PWD}/secrets/.dbt:/root/.dbt \
	-w /usr/app \
	xemuliam/dbt \
	dbt --no-partial-parse run \
	--models $(MODEL_NAME)

dbt-test: create-env
	docker run -it \
	--network $(NETWORK_NAME) \
	--name dbt \
	-v ${PWD}/$(MODEL_NAME):/usr/app \
	-v ${PWD}/secrets/.dbt:/root/.dbt \
	-w /usr/app \
	xemuliam/dbt \
	dbt --no-partial-parse test \
	--models $(MODEL_NAME)

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
	dbt-init \
	dbt-run \
	dbt-test
