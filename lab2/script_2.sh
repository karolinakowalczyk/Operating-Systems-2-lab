#!/bin/bash -eu

DIR_NOT_FOUND=10
PARAMS_NOT_FOUND=11

#Sprawdzam czy user podał argumenty
if [ $# -eq 0 ];then
    echo "No arguments supplied"
    exit ${PARAMS_NOT_FOUND}
elif [[ $# -eq 1 ]]; then
    echo "You supplied only 1 argument"
    exit ${PARAMS_NOT_FOUND}
fi


START_PATH=$(pwd)

INPUT_DIR_PATH=${1}
INPUT_FILE_PATH=${2}

echo "You gave 2 arguments - 1: ${INPUT_DIR_PATH}, 2: ${INPUT_FILE_PATH}"

# Sprawdzam czy katalog istnieje
if [[ ! -d ${INPUT_DIR_PATH} ]]; then
    echo "${INPUT_DIR_PATH} doesn t exist"
    exit "${DIR_NOT_FOUND}"
fi


# Sprawdzam czy katalog z plikiem istnieje
if [[ ! -d $(dirname "${INPUT_FILE_PATH}") ]]; then
    echo "In $(dirname "${INPUT_FILE_PATH}") file doesn t exist"
    exit "${DIR_NOT_FOUND}"
fi

#Zmieniam wszystkie ścieżki na absolutne
#Sprawdzam czy ścieżka 1 jest absolutna

if [[ "$INPUT_DIR_PATH" = /* ]]; then
    DIR_PATH=${INPUT_DIR_PATH}
    echo "--------ABSOLUTE---------"
    echo "DIR PATH: ${DIR_PATH}"
else
    echo "RELATIVE PATH"
    cd ${START_PATH}
    cd ${INPUT_DIR_PATH}

    DIR_PATH=$(pwd)"/"
    
    echo "--------RELATIVE---------"
    echo "DIR PATH: ${DIR_PATH}"

fi

#Sprawdzam czy ścieżka 2 jest absolutna
if [[ "$INPUT_FILE_PATH" = /* ]]; then
    FILE_PATH=$(dirname "${INPUT_FILE_PATH}")
    echo "--------ABSOLUTE---------"
    echo "FILE_PATH: ${FILE_PATH}"
else
    FILE_DIR=$(dirname "${INPUT_FILE_PATH}/")
    cd ${START_PATH}
    cd ${FILE_DIR}

    FILE_PATH=$(pwd)"/"

    FILE_NAME="${INPUT_FILE_PATH##*/}"

    echo "--------RELATIVE---------"
    echo "FILE_DIR: ${FILE_DIR}"
    echo "FILE PATH: ${FILE_PATH}"
    echo "FILE NAME: ${FILE_NAME}"
fi


#wchodze to katalogu 
cd ${DIR_PATH}

#zmienna w której trzymam pliki z katalogu
DIR_PATH_FILES=$(ls ${DIR_PATH})

#zmienna w ktorej trzymam uszkodzone dowiązania symboliczne
BROKEN_LINKS=$(find ./ -xtype l)

#jeżeli uszkodzone dowiązania istnieją 
if [[ ! -z ${BROKEN_LINKS} ]]; then
    #wchodze to katalogu, w którym jest plik podany przez usera
    cd ${FILE_PATH}

    CURRENT_DATE=$(date +%Y-%m-%d)

    #zapisuje aktualna date i nazwy uszkodzonych dowiązań symbolicznych do pliku
    printf "${CURRENT_DATE}\n${BROKEN_LINKS}" > ${FILE_NAME}

    #wracam do katalogu
    cd ${DIR_PATH} 

    #usuwam uszkodzone dowiązania symboliczne
    rm -r ${BROKEN_LINKS}
else
    echo "No broken symbolic link"
fi

