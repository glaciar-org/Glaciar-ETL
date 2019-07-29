#!/bin/bash

echo "----------------------------------"
echo " STAGE 0: WORKSPACE IS CLEAN      "
echo "----------------------------------"

echo "----------------------------------"
echo "    :: STEP 0: START              "
echo "    :: STEP 0: Download           "
echo "----------------------------------"

mkdir STAGE_01_Download


#----------------------------------------------------------------------------
# DATASET 04: BDHN

# declare -a arr=(
#     "caitcountryghgemissions-csv0"
#   "CAIT Country CO2 Emissions-Energy Sub-Sector.csv"
#   "CAIT Country CO2 Emissions.csv"
# )

DATASET_ID="caitcountryghgemissions-csv0"

curl -L -o "STAGE_01_Download/${DATASET_ID}.zip" http://datasets.wri.org/dataset/d1d7582d-2aa4-4d4e-a90c-8874001fa09d/resource/d3eb6615-ad58-4347-b345-20a6e774a63b/download/caitcountryghgemissions-csv0

unzip  STAGE_01_Download/${DATASET_ID}.zip -d STAGE_01_Download/${DATASET_ID}

mv     STAGE_01_Download/${DATASET_ID}/"CAIT Country CO2 Emissions"*.csv STAGE_01_Download/

rm -rf STAGE_01_Download/${DATASET_ID}
rm     STAGE_01_Download/${DATASET_ID}.zip



echo "----------------------------------"
echo "    :: STEP 0: END                "
echo "    :: STEP 0: DELIVERY           "
echo "          -> file recover in $(ls STAGE_01_Download/*) "
echo "----------------------------------"
