DIR_NOT_FOUND=10
PARAMS_NOT_FOUND=11

#Sprawdzam czy user podał argumenty
if [ $# -eq 0 ];then
    echo "No arguments supplied"
    exit ${PARAMS_NOT_FOUND}
fi

START_PATH=$(pwd)

DIR_PATH=${1}

echo "You gave dir path: ${DIR_PATH}"

# Sprawdzam czy ścieżka 1 istnieje
if [[ ! -d ${DIR_PATH} ]]; then
    echo "${DIR_PATH} doesn t exist"
    exit "${DIR_NOT_FOUND}"
fi

DIR_PATH_FILES=$(ls ${DIR_PATH})

cd ${DIR_PATH}

for FILE in ${DIR_PATH_FILES}; do
    filename=$(basename -- "${FILE}")
    extension="${filename##*.}"
    #echo "${extension}"
    
        if [[ -f "${FILE}" && "${extension}" = "bak" ]]; then
            chmod uo-w ${FILE}
        elif [[ -d "${FILE}" && "${extension}" = "bak" ]]; then
            chmod ug-x ${FILE}
            chmod o+x ${FILE}
        elif [[ -d "${FILE}" && "${extension}" = "tmp" ]]; then
            chmod a=w ${FILE}
        elif [[ -f "${FILE}" && "${extension}" = "txt" ]]; then
            #echo "$(ls -l)"
            chmod u=r,g=w,o=x ${FILE}
            #echo "$(ls -l)"
        elif [[ -f "${FILE}" && "${extension}" = "exe" ]]; then
            echo "$(ls -l)"
            chmod a=xs ${FILE}
            echo "$(ls -l)"
        fi
    
done
