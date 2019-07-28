#!/bin/bash

echo "Mongorestore from: /exchange_data/dump "

echo "Uage with: docker run -e GLACIAR_MONGO_HOST=${GLACIAR_MONGO_HOST} -e GLACIAR_MONGO_PORT=${GLACIAR_MONGO_PORT} "

mongorestore --gzip --host ${GLACIAR_MONGO_HOST} --port ${GLACIAR_MONGO_PORT} 
