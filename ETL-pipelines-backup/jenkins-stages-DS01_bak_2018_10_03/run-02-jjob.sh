#!/bin/bash

echo "----------------------------------"
echo " STAGE 1: FILE CSV IS AVAILABE    "
echo "----------------------------------"

pwd 
ls -la 
ls -la | grep dr


########################################
# I AM BREAKING THE PIPELINE
#      WITH THIS OPTION
#
if [ $1 && $1 == "--clean" ]
then
    echo "DEV MODE: --clean option"
    rm -rf STAGE_02_MongoDB
fi


source ../run-common.sh

mkdir STAGE_02_MongoDB
mkdir STAGE_02_MongoDB/STEP-01
mkdir STAGE_02_MongoDB/STEP-02
mkdir STAGE_02_MongoDB/STEP-03

DATASET_DOWN="./STAGE_01_Download"
DATASET_OUTPUT="MGSET_01_2009_2018"

echo "DATASET_DOWN = ${DATASET_DOWN}"


echo "----------------------------------"
echo "    :: STEP 1: START              "
echo "                  - wDotDecimal   "
echo "                  - wComaSep      "
echo "----------------------------------"




#----------------------------------------------------------------------------
# DATASET 01: BUENO AIRES
FILE_DOWNLOAD="calidad-de-aire-2009-2018.csv"
FILE_DOTDEC_COMMASEP="STAGE_02_MongoDB/STEP-01/${FILE_DOWNLOAD}.A.wDecDot.wCommaSep"

echo  "FILE_DOWNLOAD       =${DATASET_DOWN}/${FILE_DOWNLOAD}"
echo  "FILE_DOTDEC_COMMASEP=${DATASET_DOWN}/${FILE_DOTDEC_COMMASEP}"

# cat "${DATASET_DOWN}/${FILE_DOWNLOAD}" \
#                                        | sed -e "s:,:.:g"      \
#                                        | sed -e "s:;:,:g"      \
#                                        | sed -e "s:S/D: :g"    \
#                                        > "${FILE_DOTDEC_COMMASEP}"

cat "${DATASET_DOWN}/${FILE_DOWNLOAD}" \
                                       | sed -e "s:S/D: :g"    \
                                       > "${FILE_DOTDEC_COMMASEP}"

echo "----------------------------------"
echo "    :: STEP 1: END                "
echo "    :: STEP 1: DELIVERY           "
echo "          -> file recover in $(ls STAGE_02_MongoDB/STEP-01/*) "
echo "----------------------------------"


echo "----------------------------------"
echo "    :: STEP 2: START              "
echo "                  - MONGO FILES   "
echo "----------------------------------"

TITULOS="${DATE},${TIME},${AIRQ_CO},${AIRQ_NO2},${DATASET}\n"

csvCutColums  ${FILE_DOTDEC_COMMASEP} ${TITULOS} "-f 2-3,4-5"   "${DATASET_OUTPUT}_CE" "${DATASET_OUTPUT}" "toMongo"  "HORAS:01-24"
csvCutColums  ${FILE_DOTDEC_COMMASEP} ${TITULOS} "-f 2-3,7-8"   "${DATASET_OUTPUT}_CO" "${DATASET_OUTPUT}" "toMongo"  "HORAS:01-24"
csvCutColums  ${FILE_DOTDEC_COMMASEP} ${TITULOS} "-f 2-3,10-11" "${DATASET_OUTPUT}_BO" "${DATASET_OUTPUT}" "toMongo"  "HORAS:01-24"
csvCutColums  ${FILE_DOTDEC_COMMASEP} ${TITULOS} "-f 2-3,13-14" "${DATASET_OUTPUT}_PA" "${DATASET_OUTPUT}" "toMongo"  "HORAS:01-24"


echo "----------------------------------"
echo "    :: STEP 2: END                "
echo "    :: STEP 2: DELIVERY           "
echo "          -> file recover in: $(ls STAGE_02_MongoDB/STEP-02/*) "
echo "----------------------------------"



echo "----------------------------------"
echo "    :: STEP 3: START              "
echo "                  - UNIQUE FILE   "
echo "----------------------------------"

# TITULOS="${DATE},${TIME},${AIRQ_CO},${AIRQ_NO2},${DATASET}\n"
# printf "${TITULOS}"                                                        >  "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT}.csv"
find ./STAGE_02_MongoDB/STEP-02 -name "*_toMongo.csv" -exec  tail -n +2 {} >> "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT}.csv"   \;


echo "----------------------------------"
echo "    :: STEP 3: END                "
echo "    :: STEP 3: DELIVERY           "
echo "          -> file recover in: $(ls STAGE_02_MongoDB/STEP-03/*) "
echo "----------------------------------"
