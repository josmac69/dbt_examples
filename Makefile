create-env:
	mkdir -p postgres/app
	mkdir -p postgres/ini
	mkdir -p postgres/output
	mkdir -p secrets/.dbt
	chmod 777 -R postgres 2>/dev/null || true
	chmod 777 -R secrets 2>/dev/null || true

init-dbt: create-env
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

run-dbt: create-env
	docker run -it \
	--network $(NETWORK_NAME) \
	--name dbt \
	-v ${PWD}/pricenow_task2:/usr/app \
	-v ${PWD}/../secrets/.dbt:/root/.dbt \
	-w /usr/app \
	xemuliam/dbt \
	dbt --no-partial-parse run \
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
	run-dbt \
	clean-dbt \
	init-dbt
