#!/bin/bash

echo "Runnig: dispatch $1 "

function do_dispatch 
{
    echo " > [do_dispatch $1] (Expected ETL1-DS01 .. ETL5-DS05 )"

    cd ../ETL-pipelines/$1; 
                     ./run-00-clean.sh;
                     ./run-01-download.sh; 
                     ./run-02-transform.sh; 
                     ./run-03-mongo.sh; 
     cd ../../exchange_data
}

if [ -z "$1" ] || [ $1 == "HELP" ]
then
    echo "Usage: dispatch [ ETL1 | ETL2 | ETL3 | ETL4 | ETL5 | ETL-ALL | RESTORE | HELP (default) ]"
    exit 0
fi

if [ $1 == "ETL1" ]; then
    echo "Work for ETL1"
    do_dispatch "ETL1-DS01"
    exit 0
fi

if [ $1 == "ETL2" ]; then
    echo "Work for ETL2"
    do_dispatch "ETL2-DS02"
    exit 0
fi

if [ $1 == "ETL3" ]; then
    echo "Work for ETL3"
    do_dispatch "ETL3-DS03"
    exit 0
fi

if [ $1 == "ETL4" ]; then
    echo "Work for ETL4"
    do_dispatch "ETL4-DS04"
    exit 0
fi

if [ $1 == "ETL5" ]; then
    echo "Work for ETL5"
    do_dispatch "ETL5-DS05"
    exit 0
fi

if [ $1 == "ETL-ALL" ]; then
    echo "Work for ETL-ALL"
    do_dispatch "ETL5-DS01"
    do_dispatch "ETL5-DS02"
    do_dispatch "ETL5-DS03"
    do_dispatch "ETL5-DS04"
    do_dispatch "ETL5-DS05"
    exit 0
fi

if [ $1 == "RESTORE" ]; then
    echo "Work for RESTORE"
    ./restore.sh
    exit 0
fi


echo "ERROR: Doing nothing with $1"
echo "Usage: dispatch [ ETL1 | ETL2 | ETL3 | ETL4 | ETL5 | ETL-ALL | RESTORE | HELP (default) ]"
exit 1