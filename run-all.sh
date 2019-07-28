#!/bin/bash
cd ./ETL-pipelines/ETL1-DS01; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./ETL-pipelines/ETL2-DS02; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./ETL-pipelines/ETL3-DS03; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./ETL-pipelines/ETL4-DS04; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..
cd ./ETL-pipelines/ETL5-DS05; ./run-00-clean.sh; ./run-01-download.sh; ./run-02-transform.sh; ./run-03-mongo.sh; cd ../..