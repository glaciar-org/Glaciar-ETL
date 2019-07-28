#!/bin/bash

echo "----------------------------------"
echo " STAGE 1: FILE CSV IS AVAILABE    "
echo "----------------------------------"

########################################
# I AM BREAKING THE PIPELINE
#      WITH THIS OPTION
#
if [ $1 == "--clean" ]
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
DATASET_OUTPUT="MGSET_02_2010_2015"

echo "DATASET_DOWN = ${DATASET_DOWN}"

#----------------------------------------------------------------------------
# DATASET 02: BAHIA BLANCA

echo "----------------------------------"
echo "    :: STEP 1: START              "
echo "                  - wDotDecimal   "
echo "                  - wComaSep      "
echo "----------------------------------"

# Nothing to process for this DATASET
cp ${DATASET_DOWN}/* STAGE_02_MongoDB/STEP-01

echo "----------------------------------"
echo "    :: STEP 1: END                "
echo "    :: STEP 1: DELIVERY           "
echo "          -> file recover in ./STAGE_02_MongoDB/STEP-01 $(ls STAGE_02_MongoDB/STEP-01) "
echo "----------------------------------"


echo "----------------------------------"
echo "    :: STEP 2: START              "
echo "                  - MONGO FILES   "
echo "----------------------------------"



declare -a arr=(
    "CALID-DE-AIRE-ANO-2010"
    "CALID-DE-AIRE-ANO-2011"
    "CALID-DE-AIRE-ANO-2012"
    "CALID-DE-AIRE-ANO-2013"
    "CALID-DE-AIRE-ANO-2014"
    "CALID-DE-AIRE-ANO-2015"
)




for DATASET_ID in "${arr[@]}"
do
    FILE_DOWNLOAD="STAGE_02_MongoDB/STEP-01/${DATASET_ID}.csv"

    echo -e "\n_________\n [${DATASET_ID}]:"

    echo  "FILE_DOWNLOAD       =${FILE_DOWNLOAD}"

    TITULOS="${DATE},${TIME},${AIRQ_CO},${AIRQ_NO},${AIRQ_NO2},${DATASET}\n"
    csvCutColums  ${FILE_DOWNLOAD} ${TITULOS} "-f 1-3,6,7" "${DATASET_ID}" "${DATASET_OUTPUT}" "toMongo"

   
   
done


# rm  STAGE_02_MongoDB/*_toMongo.csv

# "Fecha","Hora","CO ppm","O3  ppb","SO2 ppb","NO pbb","NO2  pbb","NOX pbb","PM10 (µg/m3)-Promedio de 24 horas"
# "2011-01-01","00","<LD","18","0.3","0.2","2.1","2.5","43.9"
# "2011-01-01","01","<LD","15","0.3","0.2","3.2","3.5","44.3"

# FECHA,HORA,FECHA_HORA,AIRQ_CO,AIRQ_NO,AIRQ_NO2,DATASET
# "2012-01-01","00","2012-01-01:00","<LD","0.7","2.1",DATASET_02_2012
# "2012-01-01","01","2012-01-01:00","<LD","0.4","2.1",DATASET_02_2012




echo "----------------------------------"
echo "    :: STEP 2: END                "
echo "    :: STEP 2: DELIVERY           "
echo "          -> file recover in ./STAGE_02_MongoDB/STEP-02 $(ls STAGE_02_MongoDB/STEP-02 ) "
echo "----------------------------------"







echo "----------------------------------"
echo "    :: STEP 3: START              "
echo "                  - UNIQUE FILE   "
echo "----------------------------------"


# TITULOS="${DATE},${TIME},${AIRQ_CO},${AIRQ_NO},${AIRQ_NO2},${DATASET}\n"
# printf "${TITULOS}"                               >  "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT}.csv"
find ./STAGE_02_MongoDB/STEP-02 -name "*_toMongo.csv" -exec  tail -n +2 {} >> "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT}.csv"   \;

echo "----------------------------------"
echo "    :: STEP 3: END                "
echo "    :: STEP 3: DELIVERY           "
echo "          -> file recover in ./STAGE_02_MongoDB/STEP-03 $(ls STAGE_02_MongoDB/STEP-03 ) "
echo "----------------------------------"
