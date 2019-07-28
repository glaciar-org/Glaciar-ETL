#!/bin/bash

  glaciar-org-mongo-etl:
    container_name: glaciar-org-mongo-etl
    image: glaciar/glaciar.org-etl:1.0
    env_file:
      - ./.env_docker_swarm
    configs:
      - source:  glaciar_config
        target: /glaciar_config.json
    networks:
      - network-back


cd ./jenkins-pipelines-prod/ETL1-DS01; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./jenkins-pipelines-prod/ETL2-DS02; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./jenkins-pipelines-prod/ETL3-DS03; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./jenkins-pipelines-prod/ETL4-DS04; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./jenkins-pipelines-prod/ETL5-DS05; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..