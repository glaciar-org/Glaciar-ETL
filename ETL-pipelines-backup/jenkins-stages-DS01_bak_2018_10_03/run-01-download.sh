#!/bin/bash

echo "----------------------------------"
echo " STAGE 0: WORKSPACE IS CLEAN      "
echo "----------------------------------"

echo "----------------------------------"
echo "    :: STEP 0: START              "
echo "    :: STEP 0: Download           "
echo "----------------------------------"


mkdir STAGE_01_Download



declare -a arr=(
    "calidad-de-aire-2009-2018"
)



for DATASET_ID in "${arr[@]}"
do
    echo -e "\n_________\n [${DATASET_ID}]:" 

    curl  -o "STAGE_01_Download/${DATASET_ID}.zip" https://data.buenosaires.gob.ar/api/datasets/HJWHSFZmyl/download

    unzip    "STAGE_01_Download/${DATASET_ID}.zip" -d STAGE_01_Download/tmp/

    find . -name "${DATASET_ID}.csv" -exec mv {} STAGE_01_Download \;

    rm -rf STAGE_01_Download/tmp/
    rm     STAGE_01_Download/${DATASET_ID}.zip

    echo -e "\n $ head STAGE_01_Download/${DATASET_ID}.csv \n"

    head -3 "STAGE_01_Download/${DATASET_ID}.csv"

done

echo "----------------------------------"
echo "    :: STEP 0: END                "
echo "    :: STEP 0: DELIVERY           "
echo "          -> file recover in $(ls STAGE_01_Download/*.csv) "
echo "----------------------------------"


# PERIODO;FECHA;HORA;CO_CENTENARIO;NO2_CENTENARIO;PM10_CENTENARIO;CO_CORDOBA;NO2_CORDOBA;PM10_CORDOBA;CO_LA_BOCA;NO2_LA_BOCA;PM10_LA_BOCA;CO_PALERMO;NO2_PALERMO;PM10_PALERMO
# 2009;01/10/2009;15;0,48;25;S/D;S/D;30;S/D;0,16;25;S/D;1,43;S/D;S/D
# 2009;01/10/2009;16;0,48;31;S/D;S/D;32;S/D;0,14;23;S/D;1,49;S/D;S/D
# SAMPLE FILE:
#           SEPARATOS = ";"
#           DECIMAL   = ","
#     Posibilites:
#        a) Convert Decimal    "," to "." and  
#        b) Convert SEPARATOR  ";" to ","   
# 


