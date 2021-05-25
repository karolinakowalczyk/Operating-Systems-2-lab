#!/bin/bash -eu

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
    echo -e "-y YEAR\n\tSearch movies that are newer than this year"
    echo -e "-i ignore case(optional) -R regular expression\n\tSearch movies by plot."
}

function print_error () {
    echo -e "\e[31m\033[1m${*}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath ./*)
    echo "${MOVIES_LIST}"

}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_year () {
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    
    for MOVIE_FILE in ${MOVIES_LIST}; do
        local YEAR
        YEAR=$(grep -o "| Year: [0-9][0-9][0-9][0-9]" "${MOVIE_FILE}" | grep -o "[0-9][0-9][0-9][0-9]")
        if [[ ${YEAR} -gt ${QUERY} ]]; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
        
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_plot () {
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}
    if [[ ${INSENSITIVE} = true ]]; then
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Plot" "${MOVIE_FILE}" | grep -q -i -e "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    else
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Plot" "${MOVIE_FILE}" | grep -q -e "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
  fi
    echo "${RESULTS_LIST[@]:-}"
}

function print_xml_format () {
    local -r FILENAME=${1}

    local TEMP

    TEMP=$(cat "${FILENAME}")

    TEMP=$(echo "${TEMP}" | sed 's|\| Title: |<Title>|')
    TEMP=$(echo "${TEMP}" | sed 's|\| Year: |<Year>|')
    TEMP=$(echo "${TEMP}" | sed 's|\| Runtime: |<Runtime>|')
    TEMP=$(echo "${TEMP}" | sed 's|\| IMDB: |<IMDB>|')
    TEMP=$(echo "${TEMP}" | sed 's|\| Tomato: |<Tomato>|')
    TEMP=$(echo "${TEMP}" | sed 's|\| Rated: |<Rated>|')
    TEMP=$(echo "${TEMP}" | sed 's|\| Genre: |<Genre>|')
    TEMP=$(echo "${TEMP}" | sed 's|\| Director: |<Director>|')
    TEMP=$(echo "${TEMP}" | sed 's|\| Actors: |<Actors>|')
    TEMP=$(echo "${TEMP}" | sed 's|\| Plot: |<Plot>|')

    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    
    # replace first line of equals signs
    TEMP=$(echo "${TEMP}" | sed '2 s/^===*$/<movie>/')
    
    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}

function print_movies () {
    local -r MOVIES_LIST=${1}
    local -r OUTPUT_FORMAT=${2}

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}

#ANY_ERRORS=false
INSENSITIVE=false
D_OPT=false
DIR_NOT_FOUND=10
WRONG_PATH=11


while getopts ":hd:t:a:y:f:R:iR:x" OPT; do
  case ${OPT} in
    h)
        print_help
        exit 0
        ;;
    d)
        MOVIES_DIR=${OPTARG}
        D_OPT=true
        ;;
    t)
        SEARCHING_TITLE=true
        QUERY_TITLE=${OPTARG}
        ;;
    
    a)
        SEARCHING_ACTOR=true
        QUERY_ACTOR=${OPTARG}
        ;;
    y)
        SEARCHING_YEAR=true
        QUERY_YEAR=${OPTARG}
        ;; 
    f)
        FILE_4_SAVING_RESULTS=${OPTARG}

        ;;
    R)
        SEARCHING_PLOT=true
        QUERY_PLOT=${OPTARG}
        ;;
    i)
        INSENSITIVE=true
        ;;
    x)
        OUTPUT_FORMAT="xml"
        ;;
    \?)
        print_error "ERROR: Invalid option: -${OPTARG}"
        #ANY_ERRORS=true
        exit 1
        ;;
  esac
done

if [[ ${D_OPT} = false ]]; then
  echo "You don't use -d opt"
  exit ${DIR_NOT_FOUND}
fi


if [[ ! -d ${MOVIES_DIR} ]]; then
  echo "You don't put directory path"
  exit ${WRONG_PATH}
fi

MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

if ${SEARCHING_TITLE:-false}; then
    MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
fi

if ${SEARCHING_ACTOR:-false}; then
    MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
fi

if [[ "${#MOVIES_LIST}" -lt 1 ]]; then
    echo "Found 0 movies :-("
    exit 0
fi
if ${SEARCHING_YEAR:-false}; then
    MOVIES_LIST=$(query_year "${MOVIES_LIST}" "${QUERY_YEAR}")
fi
if ${SEARCHING_PLOT:-false}; then
    MOVIES_LIST=$(query_plot "${MOVIES_LIST}" "${QUERY_PLOT}")
fi
if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
else
    # TODO: add XML option
   
    if [[ ! "${FILE_4_SAVING_RESULTS}" == *".txt" ]]; then
        FILE_4_SAVING_RESULTS="${FILE_4_SAVING_RESULTS}.txt"
    fi

    print_movies "${MOVIES_LIST}" "raw" | tee "${FILE_4_SAVING_RESULTS}"
fi
