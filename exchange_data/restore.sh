#!/bin/bash

echo "Mognorestore from: /exchange_data/dump "

echo "Uage with: docker run -e GLACIAR_MOGNO_HOST=${GLACIAR_MOGNO_HOST} -e GLACIAR_MONGO_PORT=${GLACIAR_MONGO_PORT} "

mongorestore --gzip --host ${GLACIAR_MOGNO_HOST} --port ${GLACIAR_MONGO_PORT} 
