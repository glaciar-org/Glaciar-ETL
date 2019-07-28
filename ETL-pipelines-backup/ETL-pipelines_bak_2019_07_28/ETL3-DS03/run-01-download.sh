#!/bin/bash

echo "----------------------------------"
echo " STAGE 0: WORKSPACE IS CLEAN      "
echo "----------------------------------"

echo "----------------------------------"
echo "    :: STEP 0: START              "
echo "    :: STEP 0: Download           "
echo "----------------------------------"


#----------------------------------------------------------------------------
# DATASET 03: Charles River

declare -a arr=(
    "crbuoy"
    "crbuoy2017"
    "crbuoy2016"
    "crbuoy2015"
)

mkdir STAGE_01_Download

# for dd in "${DATASET_ID_LIST}"  

for DATASET_ID in "${arr[@]}"
do
    echo -e "\n_________\n [${DATASET_ID}]:" 

    curl  -o "STAGE_01_Download/${DATASET_ID}.csv" https://www.epa.gov/sites/production/files/buckeye_symlinks/region1-buoys/charles/${DATASET_ID}.csv

    echo -e "\n $ head STAGE_01_Download/${DATASET_ID}.csv \n"

    head -3 "STAGE_01_Download/${DATASET_ID}.csv"

done


echo "----------------------------------"
echo "    :: STEP 0: END                "
echo "    :: STEP 0: DELIVERY           "
echo "          -> file recover in $(ls STAGE_01_Download/*.csv) "
echo "----------------------------------"


# date,time est,temp c,spcond (ms/cm),ph,do (mg/l),do (%),turbidity (fnu),chlorophyll (rfu),phycocyanin (rfu),sysbattery
# 05/13/2015,12:00:00,22.74,.9,7.4,8.72,101.39,2.48,3.14,.45,12.92
# 05/13/2015,12:15:00,22.84,.9,7.44,8.83,102.89,2.37,3.01,.43,12.95

