#!/bin/bash

echo "Mongorestore from: /exchange_data/dump "

echo "Using with: docker run -e GLACIAR_MONGO_HOST=${GLACIAR_MONGO_HOST} -e GLACIAR_MONGO_PORT=${GLACIAR_MONGO_PORT} "


if [ -z "${GLACIAR_MONGO_HOST}" ] && [ -z "${GLACIAR_MONGO_PORT}" ] 
then
    echo "Local MongoDB mongodb://127.0.0.1:27017"
    mongorestore --gzip --drop
else
    echo "Remote MongoDB mongodb://${GLACIAR_MONGO_HOST}:${GLACIAR_MONGO_PORT}"
    mongorestore --gzip --drop --host ${GLACIAR_MONGO_HOST} --port ${GLACIAR_MONGO_PORT} 
fi

