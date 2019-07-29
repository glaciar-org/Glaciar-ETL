# GlaciaR-ETL
GlaciaR-ETL - From Open Data to MongoDB


### All in one

```sh
cd ./ETL-pipelines/ETL1-DS01; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./ETL-pipelines/ETL2-DS02; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./ETL-pipelines/ETL3-DS03; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./ETL-pipelines/ETL4-DS04; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./ETL-pipelines/ETL5-DS05; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
```

### 1.5.-mongo-db

La base de datos Mongo DB esta lenta => Debería crear indices.

```sh
db.getCollection('MGSET_02_2010_2015').createIndex({'FECHA_HORA':1})
```

Desde la línea de comandos

```sh
$ mongo --eval "db.getCollection('MGSET_02_2010_2015').createIndex({'FECHA_HORA':1})"    
MongoDB shell version v3.6.0
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.6.0
{
	"createdCollectionAutomatically" : true,
	"numIndexesBefore" : 1,
	"numIndexesAfter" : 2,
	"ok" : 1
}
```


# Docker Image Restore Initial Data

Setup initial

```sh
docker run -it --rm  --name glaciar_etl \
      -e GLACIAR_MOGNO_HOST=hostname.server.com \
	  -e GLACIAR_MONGO_PORT=2222 \
	   glaciar/glaciar.org-etl:1.0
```

o bien 

```sh
docker run -it --rm  --name glaciar_etl \
      --env-file ./.env  \
	   glaciar/glaciar.org-etl:1.0
```

Version 1.1 con parametrizado input:

```sh
docker run -it --rm --name GETL glaciar/glaciar.org-etl:1.1 ./dispatch.sh ETL1
Runnig: dispatch ETL1 
Work for ETL1

docker run -it --rm --name GETL glaciar/glaciar.org-etl:1.1 ./dispatch.sh ANYTHING
Runnig: dispatch ANYTHING
ERROR: Doing nothing with ANYTHIN
Usage: dispatch [ ETL1 | ETL2 | ETL3 | ETL4 | ETL5 | RESTORE | HELP (default) ]

docker run -it --rm --name GETL glaciar/glaciar.org-etl:1.1 ./dispatch.sh RESTORE
Runnig: dispatch RESTORE 
Work for RESTORE
Mongorestore from: /exchange_data/dump 
Uage with: docker run -e GLACIAR_MONGO_HOST= -e GLACIAR_MONGO_PORT=
```

Version 1.2 con parametrizado input:

```sh
docker run -it --rm  --name glaciar_etl \
      --env-file ./.env  \
	   glaciar/glaciar.org-etl:1.2  ./dispatch.sh ETL1
```

o bien 

```sh
docker container run -e "DOCKER_HOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')"

```