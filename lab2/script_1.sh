#!/bin/bash -eu

#nie dzialajacy link
#ln -s nieistnieje.txt link


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

DIR_PATH_1=${1}
DIR_PATH_2=${2}

echo "You gave 2 dir path - 1: ${DIR_PATH_1}, 2: ${DIR_PATH_2}"

# Sprawdzam czy ścieżka 1 istnieje
if [[ ! -d ${DIR_PATH_1} ]]; then
    echo "${DIR_PATH_1} doesn t exist"
    exit "${DIR_NOT_FOUND}"
fi


# Sprawdzam czy ścieżka 2 istnieje
if [[ ! -d ${DIR_PATH_2} ]]; then
    echo "${DIR_PATH_2} doesn t exist"
    exit "${DIR_NOT_FOUND}"
fi

#Zmieniam wszystkie ścieżki na absolutne
#Sprawdzam czy ścieżka 1 jest absolutna

if [[ "$DIR_PATH_1" = /* ]]; then
    echo "ABSOLUTE PATH"
    PATH_1=${DIR_PATH_1}
    echo "PATH 1: ${PATH_1}"
else
    echo "RELATIVE PATH"
    cd ${START_PATH}
    echo "start PATH: ${START_PATH}"
    cd ${DIR_PATH_1}

    PATH_1=$(pwd)"/"
    #PATH_1=$(pwd)
    echo "PATH 1: ${PATH_1}"

fi


#Sprawdzam czy ścieżka 2 jest absolutna
if [[ "$DIR_PATH_2" = /* ]]; then
    echo "ABSOLUTE PATH"
    PATH_2=${DIR_PATH_2}
    echo "PATH 2: ${PATH_2}"
else
    echo "RELATIVE PATH"
    cd ${START_PATH}
    echo "start PATH: ${START_PATH}"
    cd ${DIR_PATH_2}

    PATH_2=$(pwd)"/"
    #PATH_2=$(pwd)
    echo "PATH 2: ${PATH_2}"
fi

echo "--------------------------------------"

# Idę do 1 katologu 
cd "${PATH_1}"

DIR_PATH_1_FILES=$(ls ${PATH_1})

for FILE in ${DIR_PATH_1_FILES}; do
    if [[ -L ${FILE} ]]; then
        echo "This is symbolic link: ${FILE}"
    elif [[ -d ${FILE} ]]; then
        echo "This is directory: ${FILE}"
    elif [[ -f ${FILE} ]]; then
        echo "This is regular file: ${FILE}"
    fi
done

echo "--------------------------------------"

# ide do 2 katalogu 
cd "${PATH_2}"
echo "LS path 2: $(ls -l ${PATH_2})"
#echo "DIR_PATH_1_FILES: $(ls ${PATH_1})"

for ITEM in ${DIR_PATH_1_FILES}; do
    if [[ -d "${PATH_1}/${ITEM}" ]]; then
        ln -fs "${PATH_1}/${ITEM}" "${ITEM^^}_ln"
    elif [[ -f "${PATH_1}/${ITEM}" && ! -L "${PATH_1}/${ITEM}" ]]; then
        ln -fs "${PATH_1}/${ITEM}" "${ITEM^^}_ln"
    fi
done

echo "LS path 2: $(ls -l ${PATH_2})"
