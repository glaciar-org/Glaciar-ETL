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
DATASET_OUTPUT="MGSET_03_2015_2017"

echo "DATASET_DOWN = ${DATASET_DOWN}"



#----------------------------------------------------------------------------
# DATASET 03: Charles River


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
    "crbuoy"
    "crbuoy2018"
    "crbuoy2017"
    "crbuoy2016"
    "crbuoy2015"
)


for DATASET_ID in "${arr[@]}"
do
    FILE_DOWNLOAD="STAGE_02_MongoDB/STEP-01/${DATASET_ID}.csv"

    echo -e "\n_________\n [${DATASET_ID}]:"

    echo  "FILE_DOWNLOAD       =${FILE_DOWNLOAD}"

    TITULOS="${DATE},${TIME},${WATERQ_Temp},${WATERQ_pH},${WATERQ_OD},${WATERQ_OD_pc},${DATASET}\n"
    csvCutColums  ${FILE_DOWNLOAD} ${TITULOS} "-f 1-3,5-7"  "${DATASET_ID}"  "${DATASET_OUTPUT}" "toMongo"  "FECHA:yyyy-dd-mm" 

done


# rm  STAGE_02_MongoDB/*_toMongo.csv




echo "----------------------------------"
echo "    :: STEP 2: END                "
echo "    :: STEP 2: DELIVERY           "
echo "          -> file recover in ./STAGE_02_MongoDB/STEP-02 $(ls STAGE_02_MongoDB/STEP-02 ) "
echo "----------------------------------"







echo "----------------------------------"
echo "    :: STEP 3: START              "
echo "                  - UNIQUE FILE   "
echo "----------------------------------"


# TITULOS="${DATE},${TIME},${WATERQ_Temp},${WATERQ_pH},${WATERQ_OD},${WATERQ_OD_pc},${DATASET}\n"
# printf "${TITULOS}"                               >  "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT}.csv"
find ./STAGE_02_MongoDB/STEP-02 -name "*_toMongo.csv" -exec  tail -n +2 {} >> "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT}.csv"   \;

echo "----------------------------------"
echo "    :: STEP 3: END                "
echo "    :: STEP 3: DELIVERY           "
echo "          -> file recover in ./STAGE_02_MongoDB/STEP-03 $(ls STAGE_02_MongoDB/STEP-03 ) "
echo "----------------------------------"
