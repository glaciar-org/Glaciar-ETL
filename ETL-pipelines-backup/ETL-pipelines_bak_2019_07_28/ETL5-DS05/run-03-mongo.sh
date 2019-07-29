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
FILE_OUTPUT_1="STAGE_02_MongoDB/STEP-03/MGSET_WRI_CAIT_EESS_CO2.csv"
FILE_OUTPUT_2="STAGE_02_MongoDB/STEP-03/MGSET_WRI_CAIT_ETOT_CO2.csv"

TITULOS=${DATE_TIME}.date\(2006\),${DATE}.string\(\),${AIRQ_CO2}.string\(\),${DATASET}.string\(\)

if [ ${MONGODB_MLAB_UPSALA_INSERT} == "true" ]; then
        cvs2MongoDB  ${FILE_OUTPUT_1}  "MGSET_05_WRI_CAIT_EESS_CO2"  ${TITULOS} 
        cvs2MongoDB  ${FILE_OUTPUT_2}  "MGSET_05_WRI_CAIT_ETOT_CO2"  ${TITULOS} 
fi

echo "----------------------------------"
echo "    :: STEP 1: END                "
echo "----------------------------------"

