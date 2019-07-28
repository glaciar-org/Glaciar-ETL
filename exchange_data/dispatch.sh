#!/bin/bash

echo "Runnig: dispatch $1 "

if [ -z "$1" ] || [ $1 == "HELP" ]
then
    echo "Usage: dispatch [ ETL1 | ETL2 | ETL3 | ETL4 | ETL5 | RESTORE | HELP (default) ]"
    exit 0
fi

if [ $1 == "ETL1" ]; then
    echo "Work for ETL1"
    exit 0
fi

if [ $1 == "ETL2" ]; then
    echo "Work for ETL2"
    exit 0
fi

if [ $1 == "ETL3" ]; then
    echo "Work for ETL3"
    exit 0
fi

if [ $1 == "ETL4" ]; then
    echo "Work for ETL4"
    exit 0
fi

if [ $1 == "ETL5" ]; then
    echo "Work for ETL5"
    exit 0
fi

if [ $1 == "RESTORE" ]; then
    echo "Work for RESTORE"
    ./restore.sh
    exit 0
fi


echo "ERROR: Doing nothing with $1"
echo "Usage: dispatch [ ETL1 | ETL2 | ETL3 | ETL4 | ETL5 | RESTORE | HELP (default) ]"
exit 1