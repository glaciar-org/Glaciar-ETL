#!/bin/bash

echo "----------------------------------"
echo " STAGE 0: WORKSPACE UNKNOW STATUS "
echo "----------------------------------"

echo "----------------------------------"
echo "    :: STEP 0: START              "
echo "    :: STEP 0: Clean Stage Dirs   "
echo "----------------------------------"

rm -rf STAGE_01_Download
rm -rf STAGE_02_MongoDB
ls -la STAGE_0* | grep dr 

echo "----------------------------------"
echo "    :: STEP 0: END                "
echo "----------------------------------"

echo "----------------------------------"
echo "    :: STEP 1: START              "
echo "----------------------------------"

source ../run-common.sh

export ELASTIC_xHOST=${ELASTIC_CLOUD_HOST}
export ELASTIC_xUSER=${ELASTIC_CLOUD_USER}
export ELASTIC_xPASS=${ELASTIC_CLOUD_PASS}

env | grep ELASTIC_x | sort

echo "----------------------------------"
echo "    :: STEP 1: END                "
echo "----------------------------------"

echo "----------------------------------"
echo " STAGE 0: DELIVERY                "
echo "          -> Empty dirs $(ls -la STAGE_0* | grep dr )"
echo "          -> ENV SETUP  $(env | grep ELASTIC_x | sort )"
echo "----------------------------------"