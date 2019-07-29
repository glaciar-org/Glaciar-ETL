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
DATASET_OUTPUT="MGSET_05_1990_2012"

echo "DATASET_DOWN = ${DATASET_DOWN}"

echo "----------------------------------"
echo "    :: STEP 1: START              "
echo "                  - wDotDecimal   "
echo "                  - wComaSep      "
echo "----------------------------------"




#----------------------------------------------------------------------------
# DATASET 05: WRI

function grepXpais
{  
    echo "grepXpais('"$1"'):" 

    FILE_INPUT="${DATASET_DOWN}"/"${2}" 
    FILE_OUTPUT="STAGE_02_MongoDB/STEP-01/${3}_${1}.csv"

    TITULOS=`head -n 2 "${FILE_INPUT}" | tail -1 `

    echo      ${TITULOS}     >  "${FILE_OUTPUT}"
    egrep $1 "${FILE_INPUT}" >> "${FILE_OUTPUT}"
} 

declare -a arr=(
    "Argentina"
    "Brazil"
    "Bolivia"
    "Germany"
    "Chile"
)

for PAIS in "${arr[@]}"
do
    grepXpais ${PAIS} "CAIT Country CO2 Emissions-Energy Sub-Sector.csv" "WRI_CAIT_EESS_CO2_grepXpais"
    grepXpais ${PAIS} "CAIT Country CO2 Emissions.csv"                   "WRI_CAIT_ETOT_CO2_grepXpais"
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


for FILE in ./STAGE_02_MongoDB/STEP-01/WRI_CAIT_EESS_CO2_grepXpais*.csv; do

    [[ -e $FILE ]] || continue
    echo "file A: " ${FILE}

    IFS='_.' read -a pathArray <<< "${FILE}"

    PAIS="${pathArray[8]}"

    echo "      pathArray[@]=[${pathArray[@]}]"
    echo "PAIS: pathArray[8]="${PAIS}

    DATASET_ID="WRI_CAIT_EESS_CO2_${PAIS}"
    DATASET_OUTPUT="MGSET_WRI_CAIT_EESS_CO2"

    TITULOS="${DATE},${AIRQ_CO2},${DATASET}\n"
    csvCutColums  ${FILE} ${TITULOS} "-f 2,3"  "${DATASET_ID}_Electricity"    "${DATASET_OUTPUT}" "toMongo" "YEAR"
    csvCutColums  ${FILE} ${TITULOS} "-f 2,4"  "${DATASET_ID}_Construction"   "${DATASET_OUTPUT}" "toMongo" "YEAR"
    csvCutColums  ${FILE} ${TITULOS} "-f 2,5"  "${DATASET_ID}_Transportation" "${DATASET_OUTPUT}" "toMongo" "YEAR"
    csvCutColums  ${FILE} ${TITULOS} "-f 2,6"  "${DATASET_ID}_Other"          "${DATASET_OUTPUT}" "toMongo" "YEAR"

done


for FILE in ./STAGE_02_MongoDB/STEP-01/WRI_CAIT_ETOT_CO2_grepXpais*.csv; do

    [[ -e $FILE ]] || continue
    echo "file B: " ${FILE}

    IFS='_.' read -a pathArray <<< "${FILE}"

    PAIS="${pathArray[8]}"


    TMPFILE=./STAGE_02_MongoDB/STEP-02/tmpFILE_${PAIS}.csv

    # REMOVE <CR> at END OF LINE ON OSX FILES .... SEE BELOW
    cat $FILE | tr '\r' ',' > ${TMPFILE}

    echo "      pathArray[@]=[${pathArray[@]}]"
    echo "PAIS: pathArray[8]="${PAIS}

    DATASET_ID="WRI_CAIT_ETOT_CO2_${PAIS}"
    DATASET_OUTPUT="MGSET_WRI_CAIT_EESS_CO2"

    TITULOS="${DATE},${AIRQ_CO2},${DATASET}\n"
    csvCutColums  ${TMPFILE} ${TITULOS} "-f 2,3"  "${DATASET_ID}"    "${DATASET_OUTPUT}" "toMongo" "YEAR"


    rm ${TMPFILE}
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

DATASET_OUTPUT_EESS="MGSET_WRI_CAIT_EESS_CO2"
DATASET_OUTPUT_ETOT="MGSET_WRI_CAIT_ETOT_CO2"

# TITULOS="${DATE},${AIRQ_CO2},${DATASET}\n"

# printf "${TITULOS}"                                                             >  "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT_EESS}.csv"
find ./STAGE_02_MongoDB/STEP-02 -name "*EESS*_toMongo.csv" -exec  tail -n +2 {} >> "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT_EESS}.csv"   \;

# printf "${TITULOS}"                                                             >  "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT_ETOT}.csv"
find ./STAGE_02_MongoDB/STEP-02 -name "*ETOT*_toMongo.csv" -exec  tail -n +2 {} >> "STAGE_02_MongoDB/STEP-03/${DATASET_OUTPUT_ETOT}.csv"   \;


echo "----------------------------------"
echo "    :: STEP 3: END                "
echo "    :: STEP 3: DELIVERY           "
echo "          -> file recover in ./STAGE_02_MongoDB/STEP-03 $(ls STAGE_02_MongoDB/STEP-03 ) "
echo "----------------------------------"





# https://stackoverflow.com/questions/9260126/what-are-the-differences-between-char-literals-n-and-r-in-java
# \n is a line feed (LF) character, character code 10. 
# \r is a carriage return (CR) character, character code 13.
# What they do differs from system to system. 
# On Windows, lines in text files are terminated using CR followed immediately by LF (e.g., CRLF). 
# On Unix systems and their derivatives, only LF is used.
#  (    Macs prior to Mac OS X used CR, 
#   but Mac OS X is a *nix derivative and so uses LF.)

# http://hints.macworld.com/article.php?story=20031018164326986
# To display mac text files at the command line in Terminal.app (or to pipe this to a new file),
#  I created a script called "mac2unix" that contains one line:
# cat $1 | tr '\r' '\n'

# To convert unix files to Mac files, here is "unix2mac":
# cat $1 | tr '\n' '\r'

# To convert DOS files to unix files, here is "dos2unix":
# cat $1 | tr -d '\r'