#!/bin/bash
SOURCE_DIR=${1:-"lab_uno"}
RM_LIST=${2:-"lab_uno/2remove"}
TARGET_DIR=${3:-"bakap"}
#echo "You give 3 arguments: ${SOURCE_DIR}, ${RM_LIST}, ${TARGET_DIR}"


if [[ ! (-d "${TARGET_DIR}")]]; then
    echo -e "Catalog TARGET_DIR doesn't exist\n Don't worry, I created it \n"
    mkdir "${TARGET_DIR}"
fi


LIST=$(cat ${RM_LIST})

for ITEM in ${LIST}; do
    if [[ -e ${SOURCE_DIR}/${ITEM} ]]; then
        rm -r ${SOURCE_DIR}/${ITEM}
    fi
done

LIST2=$(ls ${SOURCE_DIR})

for ITEM in ${LIST2}; do
    if [[ -d ${SOURCE_DIR}/${ITEM} ]]; then
        cp -avr ${SOURCE_DIR}/${ITEM} ${TARGET_DIR}/  
    else
        mv -f ${SOURCE_DIR}/${ITEM} ${TARGET_DIR}/    
    fi
done

FILES_NUMBER=$(ls ${SOURCE_DIR} | wc -l)
if [ -z "$(ls -A ${SOURCE_DIR})" ]; then
    echo "There was Kononowicz"
else
    echo "There is something else left..."
    if [[ ${FILES_NUMBER} -ge 2 ]]; then
        echo "At least 2 files "
        if [[ ${FILES_NUMBER} -gt 4 ]]; then
            echo "and more than 4 files left"
        elif [[ ${FILES_NUMBER} -le 4 ]]; then
            echo "and lower or equal 4 files left"
        fi
    fi
fi

LIST3=$(ls ${TARGET_DIR})
for ITEM in ${LIST3}; do
    $(chmod -R 555 ${TARGET_DIR}/${ITEM}) 
done
DATE=$(date '+%Y-%m-%d')
zip -r bakap_${DATE}.zip ${TARGET_DIR}