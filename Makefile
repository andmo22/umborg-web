APP_SERVICE=umborg-web-umborg-web-1
WORKDIR=$(shell pwd)

setup:
	docker compose down
	docker compose build
	docker compose up -d

stop:
	docker compose down

clean: stop
	docker compose down --volumes --rmi all

restart: stop setup

logs:
	docker compose logs -f $(APP_SERVICE)
	
exec:
	@if [ "$$OS" = "Windows_NT" ]; then \
		winpty docker exec -it $(APP_SERVICE) bash; \
	else \
		docker exec -it $(APP_SERVICE) /bin/sh; \
	fi

shell: exec

push:
	docker tag umborg-web:latest andmo22/umborg-web:latest
	docker push andmo22/umborg-web:latest
	
deploy-test:
	kubectl delete pod -l 'app in (umborg-web)' --namespace umborg-web-test