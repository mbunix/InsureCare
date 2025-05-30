postgres:
	docker run -d --name postgrescms -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret  -v /data/logs -p 5432:5432 postgres:17-alpine

createdb:
	docker exec -it postgrescms createdb --username=root --owner=root CMSLender

dropdb: 
	docker exxec -it postgrescms dropdb CMSLender

.PHONY:postgres createdb dropdb
