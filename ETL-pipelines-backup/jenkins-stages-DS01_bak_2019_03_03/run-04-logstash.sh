#!/bin/bash
echo "----------------------------------"
echo " STAGE 3: ELSTIC FILES AVAILABE   "
echo "----------------------------------"

source ../run-common.sh

export ELASTIC_xHOST="${ELASTIC_CLOUD_HOST}"
export ELASTIC_xUSER="${ELASTIC_CLOUD_USER}"
export ELASTIC_xPASS="${ELASTIC_CLOUD_PASS}"

echo "ELASTIC_xHOST = ${ELASTIC_xHOST}"
echo "ELASTIC_xUSER = ${ELASTIC_xUSER}"
echo "ELASTIC_xPASS = ${ELASTIC_xPASS}"

export ELK_STACK_UELA_DATASET=` pwd `/STAGE_02_MongoDB
export ELK_STACK_UELA_LOGCONF=` pwd `/config-logstash


# /usr/local/bin/logstash -f ${ELK_STACK_UELA_LOGCONF}/logstash-dataset-01.all.conf --config.reload.automatic


## TODO: Se puede hacer esto con un Docker
##       O sea, ejecutar este paso ... 

