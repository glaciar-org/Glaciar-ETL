#!/bin/bash

# Constantes de los campos:
export DATE="FECHA"
export TIME="HORA"
export AMPM="AMPM"
export DATE_TIME="FECHA_HORA"
export DATASET="DATASET"
export SOURCE="SOURCE"
export LABEL="LABEL"

export AIRQ_CO="AIRQ_CO"
export AIRQ_CO2="AIRQ_CO2"
export AIRQ_NO="AIRQ_NO"
export AIRQ_NO2="AIRQ_NO2"

export WATERQ_Cond="WATERQ_Cond"
export WATERQ_Cond25="WATERQ_Cond25"
export WATERQ_OD="WATERQ_OD"
export WATERQ_OD_pc="WATERQ_OD_pc"
export WATERQ_Redox="WATERQ_Redox"
export WATERQ_Temp="WATERQ_Temp"
export WATERQ_pH="WATERQ_pH"
export WATERQ_Sal="WATERQ_Sal"  # Este esta de mas

DO_CSVMONGO=false

DATASET_MONGO=./STAGE_02_MongoDB/STEP-02


echo "-----------------------------------"
echo " > [run-common.sh] loading ...       "
echo "-----------------------------------"


# Config & Export Env (dotnode) Levels
function doConfigEnv 
{
    echo " > [run-common.sh] doConfigEnv"

    # Export the vars in .env into your shell:
    export ENV_LOCAL_FILE=.env

    # if [ -f .env ]; then
    #     ENV_LOCAL_FILE=.env
    # fi

    if [ -f ../.env ]; then
        ENV_LOCAL_FILE=../.env
    fi

    echo "ENV_LOCAL_FILE ${ENV_LOCAL_FILE}"
    

    # Cascade Behaviour
    export $(egrep -v '^#' ${ENV_LOCAL_FILE}  | xargs)

}

doConfigEnv


# --------------------------------------------------------------------------------
# cvs2MongoDB (Nota, lo puedo poner también por LogsTash) ¿Que ventaja tendría?
# NOTA: Con esta forma de Inserción, las fechas entran como String (no como Date/ISODate)
#       Pero la hora entra como un INT 32
# SOLUTION:
#       https://stackoverflow.com/questions/6475987/importing-date-datatype-using-mongoimport/14876386#14876386 
#       https://docs.mongodb.com/manual/reference/program/mongoimport/#cmdoption-columnshavetypes 
#       (--columnsHaveTypes)
#       mongoimport --db your-db-name 
#                   --type csv 
#                   --file your-file.csv 
#                   --collection your-collection
#                   --fields timestamp.date\(2006-01-02\ 15:04:05.00000+00\)
#                                                    ,count.int32\(\), --columnsHaveType


# mongoimport -h foohost -d bardb -c fooc --type tsv --fields col1,col2,col3                                                    --file path/to/file.txt
# mongoimport -h foohost -d bardb -c fooc --type tsv --fields col1.int32\(\),col2.double\(\),col3.string\(\) --columnsHaveTypes --file path/to/file.txt

# --fields col1.int32\(\),col2.double\(\),col3.string\(\)
# --fields FECHA.date\(2006-01-02\ 15:04:0 5.00000+00\),count.int32\(\)
# FECHA,HORA,AIRQ_CO,AIRQ_NO,AIRQ_NO2,DATASET


MONGODB_HOST=${MONGODB_MLAB_UPSALA_HOST}
MONGODB_BASE=${MONGODB_MLAB_UPSALA_BASE}
MONGODB_USER=${MONGODB_MLAB_UPSALA_USER}
MONGODB_PASS=${MONGODB_MLAB_UPSALA_PASS}

# https://docs.mongodb.com/manual/reference/program/mongo/
# Authentication Options
# --authenticationDatabase <dbname>
# Specifies the database in which the user is created. See Authentication Database.
# If you do not specify a value for --authenticationDatabase, mongo uses the database specified in the connection string.
function mongodbCreateIndex
{
    echo " > [run-common.sh] mongodbCreateIndex: COLLECTION : ${1}"

    if [ "PWD:"${MONGODB_PASS} != "PWD:" ]; then

        echo "mongodbCreateIndex -->  WIP "
        # mongo    ${MONGODB_BASE} \
        #       -h ${MONGODB_HOST}  \
        #       -u ${MONGODB_USER} -p ${MONGODB_PASS} \
        #       --authenticationDatabase  ${MONGODB_BASE} \
        #       --eval "db.getCollection('${1}').createIndex({'FECHA_HORA':1})"
    fi

    if [ "PWD:"${MONGODB_PASS} == "PWD:" ]; then

        mongo ${MONGODB_BASE} \
              --eval "db.getCollection('${1}').createIndex({'FECHA_HORA':1})"
    fi
}



function cvs2MongoDB
{
    echo " > [run-common.sh] cvs2MongoDB: FILE       : ${1}"
    echo " > [run-common.sh] cvs2MongoDB: COLLECTION : ${2}"
    echo " > [run-common.sh] cvs2MongoDB: TITULOS    : ${3}"

    echo " > [run-common.sh] $ mongoimport -h ${MONGODB_HOST} -d ${MONGODB_BASE} \
                -u ${MONGODB_USER} -p ${MONGODB_PASS} \
                --type csv  --headerline \
                --file ${1} -c ${2}"

    if [ "PWD:"${MONGODB_PASS} != "PWD:" ]; then
        mongoimport -h ${MONGODB_HOST} -d ${MONGODB_BASE} \
                    -u ${MONGODB_USER} -p ${MONGODB_PASS} \
                    --type csv          \
                    --fields ${TITULOS}  \
                    --columnsHaveTypes    \
                    --file ${1} -c ${2}    \
                    --drop
    fi



    if [ "PWD:"${MONGODB_PASS} == "PWD:" ]; then


# FECHA,HORA,AIRQ_CO,AIRQ_NO,AIRQ_NO2,DATASET
# "2010-01-01":"00","2010-01-01","00","<LD","---","---",CALID-DE-AIRE-ANO-2010
# "2010-01-01":"01","2010-01-01","01","<LD","---","---",CALID-DE-AIRE-ANO-2010
# "2015/12/24","04","0.19","0.2","3.0",CALID-DE-AIRE-ANO-2015
# "2015-12-24","05","0.20","0.9","5.2",CALID-DE-AIRE-ANO-2015

# "2015-11-21T00:00:00.000Z"
# 2006-01-02 15:04:05

        mongoimport -h ${MONGODB_HOST} -d ${MONGODB_BASE} \
                    --type csv          \
                    --fields ${TITULOS}  \
                    --columnsHaveTypes    \
                    --file ${1} -c ${2}    \
                    --drop

    fi

    mongodbCreateIndex ${2}

}
# --------------------------------------------------------------------------------


function csvCutColums
{

    MY_TITULO=${2}
    MY_DATASET=${4}
    MY_FILEOUT=${4}

    if [ ${6} != "" ]; then
         echo " > [run-common.sh] hacemos!:  SOURCE: ${6} [Opcional]"
         MY_FILEOUT=${4}"_${6}"
    fi

    echo " > [run-common.sh] csvCutColums:  FILE       : ${1}"
    echo " > [run-common.sh] csvCutColums:  titulos    : ${2}"
    echo " > [run-common.sh] csvCutColums:  cut -f     : ${3}"
    echo " > [run-common.sh] csvCutColums:  Dataset    : ${4}"
    echo " > [run-common.sh] csvCutColums:  Mongoset   : ${5}"
    echo " > [run-common.sh] {"
    echo " > [run-common.sh]       SOURCE [Opcional]   : ${6}"
    echo " > [run-common.sh]       MY_FILEOUT          : ${MY_FILEOUT}"
    echo " > [run-common.sh]       OPTIONS             : ${7}"
    echo " > [run-common.sh] }"


    FILE_OUTPUT="${DATASET_MONGO}/${MY_FILEOUT}.csv"
    FILE_OUTPUT_TMP="${FILE_OUTPUT}.tmp"

# FECHA,HORA,AMPM,DATASET,SOURCE
# FECHA,HORA,AMPM,WATERQ_OD_pc,DATASET_04_PP,WATERQ_OD_pc
# 01/08/2013,03:48:00,p.m.,62.1,DATASET_04_PP,WATERQ_OD_pc
# https://www.tutorialspoint.com/awk/awk_string_functions.htm

# n '2012-04-01:12:00:00 AM'
# echo -e "cat\nbat\nfun\nfin\nfan" | awk '/f.n/'

# echo -e "2012-04-01:12:00:00 AM" | awk ' { split($0, arr, ":"); print arr; }'

# $ FOO="Esto es una prueba"; awk -v prueba="$FOO" 'BEGIN {print prueba}'
# Esto es una prueba

    printf "${MY_TITULO}"  > "${FILE_OUTPUT}.tmp"

    # > "${FILE_OUTPUT}"

    tail -n +2 "${1}" | cut -d, ${3}                 \
                      | sed -e "s/$/,${MY_DATASET}/g" \
                      | sed -e "s/,,/,/g"              \
                       >> "${FILE_OUTPUT_TMP}"

    awk -v OPTIONS="${7}" \
        'BEGIN { FS="," } 
        /^(\")?[A-Za-z]/ { print "\"FECHA_HORA\"" "," $0; }
        /^(\")?[0-9]/    { 

                            # print "OPTIONS=" OPTIONS

                            gsub(/\"/,"",$0);

                            HORA=""
                            split($2, arrH, "[:]")
                            if (arrH[1]=="") { arrH[1]="00" } # HH 
                            if (arrH[2]=="") { arrH[2]="00" } # MM
                            if (length(arrH[1])==1) { arrH[1]="0"arrH[1] } 
                            if (length(arrH[2])==1) { arrH[2]="0"arrH[2] } 

                            if (OPTIONS=="HORAS:01-24") { arrH[1]=arrH[1]-1 }
                            HORA=":" arrH[1] ":" arrH[2]

                            FECHA=""
                            split($1, arrF, "[-/]")
                            if (length(arrF[1])==4) { FECHA=arrF[1] "-" arrF[2] "-" arrF[3] }  
                            if (length(arrF[3])==4) { FECHA=arrF[3] "-" arrF[2] "-" arrF[1] }

                            if (OPTIONS=="FECHA:yyyy-dd-mm") { FECHA=arrF[3] "-" arrF[1] "-" arrF[2] }

                            if (OPTIONS=="YEAR") { FECHA=$1; HORA="" }
                            print FECHA HORA "," $0; 

                          }' \
        ${FILE_OUTPUT_TMP} > ${FILE_OUTPUT}

    echo -e "\n $ head ${FILE_OUTPUT} \n"

    head -3 "${FILE_OUTPUT}"

    if [ ${DO_CSVMONGO} == "true" ]; then
         cvs2MongoDB ${FILE_OUTPUT} ${5}
    fi


    rm ${FILE_OUTPUT_TMP}

}

echo "-----------------------------------"
echo " > [run-common.sh] present!        "
echo "-----------------------------------"



env | grep MONGO | sort 

echo "-----------------------------------"
echo " > [run-common.sh] check!          "
echo "-----------------------------------"
