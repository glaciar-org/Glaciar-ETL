#!/bin/bash

echo "----------------------------------"
echo " STAGE 2: MONGO FILES AVAILABE    "
echo "----------------------------------"

source ../run-common.sh

echo " MONGODB_BASE=${MONGODB_MLAB_UPSALA_BASE}"
echo " MONGODB_HOST=${MONGODB_MLAB_UPSALA_HOST}"
echo " MONGODB_USER=${MONGODB_MLAB_UPSALA_USER}"
echo " MONGODB_PASS=${MONGODB_MLAB_UPSALA_PASS}"


echo "----------------------------------"
echo "    :: STEP 1: START              "
echo "----------------------------------"


MONGODB_MLAB_UPSALA_INSERT="true"
FILE_OUTPUT="STAGE_02_MongoDB/STEP-03/MGSET_04_2010_2015-PRN.csv"

TITULOS=${DATE_TIME}.date\(2006-01-02:15:04\),${DATE}.string\(\),${TIME}.string\(\),${AMPM}.string\(\),${LABEL}.string\(\),${DATASET}.string\(\)

if [ ${MONGODB_MLAB_UPSALA_INSERT} == "true" ]; then
        cvs2MongoDB  ${FILE_OUTPUT}  "MGSET_04_2010_2015-PRN" ${TITULOS} 
fi


echo "----------------------------------"
echo "    :: STEP 1: END                "
echo "----------------------------------"

