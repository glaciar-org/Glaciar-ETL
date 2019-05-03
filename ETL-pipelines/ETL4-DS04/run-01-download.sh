#!/bin/bash

echo "----------------------------------"
echo " STAGE 0: WORKSPACE IS CLEAN      "
echo "----------------------------------"

echo "----------------------------------"
echo "    :: STEP 0: START              "
echo "    :: STEP 0: Download           "
echo "----------------------------------"


#----------------------------------------------------------------------------
# DATASET 04: BDHN

declare -a arr=(
    "BDHN-public-dataset"
)

mkdir STAGE_01_Download

# for dd in "${DATASET_ID_LIST}"  

for DATASET_ID in "${arr[@]}"
do
    echo -e "\n_________\n [${DATASET_ID}]:" 

     curl   https://raw.githubusercontent.com/PabloEzequiel/shared-images/master/Upsala/public-dataset/BDHN-public-dataset.tar.gz -o STAGE_01_Download/BDHN-public-dataset.tar.gz

    tar -xzvf STAGE_01_Download/BDHN-public-dataset.tar.gz --directory STAGE_01_Download/

    mv     STAGE_01_Download/BDHN-public-dataset/* STAGE_01_Download/

    rm -rf STAGE_01_Download/BDHN-public-dataset
    rm     STAGE_01_Download/BDHN-public-dataset.tar.gz

   
done


echo "----------------------------------"
echo "    :: STEP 0: END                "
echo "    :: STEP 0: DELIVERY           "
echo "          -> file recover in $(ls STAGE_01_Download/*) "
echo "----------------------------------"
