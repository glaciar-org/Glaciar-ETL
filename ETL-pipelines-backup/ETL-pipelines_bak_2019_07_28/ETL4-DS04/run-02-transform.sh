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
DATASET_OUTPUT="MGSET_04_2010_2015"

echo "DATASET_DOWN = ${DATASET_DOWN}"

echo "----------------------------------"
echo "    :: STEP 1: START              "
echo "                  - wDotDecimal   "
echo "                  - wComaSep      "
echo "----------------------------------"




#----------------------------------------------------------------------------
# DATASET 04: BDHNs

declare -a arr=(

    "Rio-Estacion-Gualeguay/Datos_Conductividad Electrica.xls;${WATERQ_Cond};GGY"
    "Rio-Estacion-Gualeguay/Datos_Conductividad Especifica a 25.xls;${WATERQ_Cond25};GGY"
    "Rio-Estacion-Gualeguay/Datos_Oxigeno Disuelto.xls;${WATERQ_OD};GGY"
    "Rio-Estacion-Gualeguay/Datos_Porcentaje de Oxigeno Disuelto.xls;${WATERQ_OD_pc};GGY"
    "Rio-Estacion-Gualeguay/Datos_Potencial Oxido Reduccion.xls;${WATERQ_Redox};GGY"
    "Rio-Estacion-Gualeguay/Datos_TEMPERATURA DEL AGUA.xls;${WATERQ_Temp};GGY"
    "Rio-Estacion-Gualeguay/Datos_pH.xls;${WATERQ_pH};GGY"
    # "Rio-Estacion-Gualeguay/Datos_Salinidad.xls;${WATERQ_Sal};GGY"                    # NO EXISTE ¿Porque no lo descargue?

    "Rio-Estacion-Paraguay/Datos_Conductividad Electrica.xls;${WATERQ_Cond};PGY"
    "Rio-Estacion-Paraguay/Datos_Conductividad Especifica a 25.xls;${WATERQ_Cond25};PGY"
    "Rio-Estacion-Paraguay/Datos_Oxigeno Disuelto.xls;${WATERQ_OD};PGY"
    "Rio-Estacion-Paraguay/Datos_Porcentaje de Oxigeno Disuelto.xls;${WATERQ_OD_pc};PGY"
    "Rio-Estacion-Paraguay/Datos_Potencial Oxido Reduccion.xls;${WATERQ_Redox};PGY"
    "Rio-Estacion-Paraguay/Datos_TEMPERATURA DEL AGUA.xls;${WATERQ_Temp};PGY"
    "Rio-Estacion-Paraguay/Datos_pH.xls;${WATERQ_pH};PGY"
    "Rio-Estacion-Paraguay/Datos_Salinidad.xls;${WATERQ_Sal};PGY"

    "Rio-Estacion-Parana/Datos_Conductividad Electrica.xls;${WATERQ_Cond};PRN"
    "Rio-Estacion-Parana/Datos_Conductividad Especifica a 25.xls;${WATERQ_Cond25};PRN"
    "Rio-Estacion-Parana/Datos_Oxigeno Disuelto.xls;${WATERQ_OD};PRN"
    "Rio-Estacion-Parana/Datos_Porcentaje de Oxigeno Disuelto.xls;${WATERQ_OD_pc};PRN"
    "Rio-Estacion-Parana/Datos_Potencial Oxido Reduccion.xls;${WATERQ_Redox};PRN"
    "Rio-Estacion-Parana/Datos_TEMPERATURA DEL AGUA.xls;${WATERQ_Temp};PRN"
    "Rio-Estacion-Parana/Datos_pH.xls;${WATERQ_pH};PRN"
    # "Rio-Estacion-Parana/Datos_Salinidad.xls;${WATERQ_Sal};PRN"                    # NO EXISTE ¿Porque no lo descargue?

)



#
# Esta es específica de la BDHN
#
function format2CSV
{
    # echo "format2CSV:  file     : ${1}"
    # echo "format2CSV:  titulos  : ${2}"
    # echo "format2CSV:  variable : ${3}"
    # echo "format2CSV:  dataset  : ${4}"


    FILE_INPUT="${DATASET_DOWN}/${1}"
    FILE_OUTPUT="STAGE_02_MongoDB/STEP-01/Datos-${3}.csv"

    # sed -i 's|^M||g'   ${FILE_INPUT}

    tail +5  "${FILE_INPUT}" \
                             | sed -e "/^[^(0-9)]/d"   \
                             | sed -e "s:,:.:g"        \
                             | sed -e "s:^[ ]*$::g"    \
                             | sed -e "s: :,:g"        \
                             | sed -e "s:	:,:g"      \
                             | sed -e "s:,,:,:g"       \
                             > ${FILE_OUTPUT}



    printf   "${2}"  >> "${FILE_OUTPUT}"
    sort -n "${FILE_OUTPUT}" -o "${FILE_OUTPUT}"

    echo ""
}


for DATASET_IN in "${arr[@]}"
do

    IFS=';' read -a myarray <<< "$DATASET_IN"

    FILE_ID="${myarray[0]}"
    VARIABLE="${myarray[1]}"
    ESTACION_ID="${myarray[2]}"

    TITULOS="${DATE},${TIME},${AMPM},${VARIABLE}"

    format2CSV "${FILE_ID}" "${TITULOS}" "${ESTACION_ID}-${VARIABLE}" "DATASET_04_2011_2017_${ESTACION_ID}"

done

echo "----------------------------------"
echo "    :: STEP 1: END                "
echo "    :: STEP 1: DELIVERY           "
echo "          -> file recover in ./STAGE_02_MongoDB/STEP-01 $(ls STAGE_02_MongoDB/STEP-01) "
echo "----------------------------------"


echo "----------------------------------"
echo "    :: STEP 2: START              "
echo "                  - MONGO FILES   "
echo "----------------------------------"

for FILE in ./STAGE_02_MongoDB/STEP-01/Datos-*.csv; do

    [[ -e $FILE ]] || continue
    echo "file: " ${FILE}

    IFS='/-.' read -a pathArray <<< "${FILE}"


    DATASET_TAG="${pathArray[6]}"
    DATASET_VAR="${pathArray[7]}"

    echo "             pathArray[@]=[${pathArray[@]}]"
    echo "DATASET_TAG: pathArray[6]="${DATASET_TAG}
    echo "DATASET_VAR: pathArray[7]="${DATASET_VAR}

    DATASET_ID="DATASET-${DATASET_TAG}-${DATASET_VAR}"
    DATASET_OUTPUT="MGSET_04_2010_2015-${DATASET_TAG}"

    TITULOS="${DATE},${TIME},${AMPM},${DATASET_VAR},${DATASET}\n"
    csvCutColums  ${FILE} ${TITULOS} "-f 1-4"  "${DATASET_ID}"  "${DATASET_OUTPUT}" "toMongo"

done


echo "----------------------------------"
echo "    :: STEP 2: END                "
echo "    :: STEP 2: DELIVERY           "
echo "          -> file recover in ./STAGE_02_MongoDB/STEP-02 $(ls STAGE_02_MongoDB/STEP-02 ) "
echo "----------------------------------"




echo "----------------------------------"
echo "    :: STEP 3: START              "
echo "                  - UNIQUE FILE   "
echo "----------------------------------"

# TITULOS="${DATE},${TIME},${AMPM},${LABEL},${DATASET}\n"
# printf "${TITULOS}"                                                        >  "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT}.csv"
find ./STAGE_02_MongoDB/STEP-02 -name "*_toMongo.csv" -exec  tail -n +2 {} >> "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT}.csv"   \;


echo "----------------------------------"
echo "    :: STEP 3: END                "
echo "    :: STEP 3: DELIVERY           "
echo "          -> file recover in ./STAGE_02_MongoDB/STEP-03 $(ls STAGE_02_MongoDB/STEP-03 ) "
echo "----------------------------------"
