#!/bin/bash

echo "----------------------------------"
echo " STAGE 0: WORKSPACE IS CLEAN      "
echo "----------------------------------"

echo "----------------------------------"
echo "    :: STEP 0: START              "
echo "    :: STEP 0: Download           "
echo "----------------------------------"

#####################################################################
# BAHIA BLANCA API KEY
BAHIA_BLANCA_API_KEY=d6779093d248f4100fa22cae73aed529df161097

API_KEY=${BAHIA_BLANCA_API_KEY}

declare -a arr=(
    "CALID-DE-AIRE-ANO-2010"
    "CALID-DE-AIRE-ANO-2011"
    "CALID-DE-AIRE-ANO-2012"
    "CALID-DE-AIRE-ANO-2013"
    "CALID-DE-AIRE-ANO-2014"
    "CALID-DE-AIRE-ANO-2015"
)


mkdir STAGE_01_Download

# for dd in "${DATASET_ID_LIST}"  

for DATASET_ID in "${arr[@]}"
do
    echo -e "\n_________\n [${DATASET_ID}]:" 

    curl  -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
          -o "STAGE_01_Download/${DATASET_ID}.csv" http://api.datos.bahiablanca.gob.ar/api/v2/datastreams/${DATASET_ID}/data.csv/?auth_key=${API_KEY}

    echo -e "\n $ head STAGE_01_Download/${DATASET_ID}.csv \n"

    head -3 "STAGE_01_Download/${DATASET_ID}.csv"

done


echo "----------------------------------"
echo "    :: STEP 0: END                "
echo "    :: STEP 0: DELIVERY           "
echo "          -> file recover in $(ls STAGE_01_Download/*.csv) "
echo "----------------------------------"


# "Fecha","hora","CO ppm","O3  ppb","SO2 ppb","NO  pbb","NO2  pbb","NOX  pbb","PM10 (µg/m3)-Promedio de 24 horas"
# "2015-01-01","00","0.06","22","0.3","0.2","1.6","1.5","35.0"
# "2015-01-01","01","0.05","20","0.3","0.3","1.8","1.8","34.9"




