#!/bin/bash -eu

FILE_NOT_FOUND=10

YOLO_FILE="./yolo.csv"

if [[ ! -f ${YOLO_FILE} ]]; then
    echo "File not found"
    exit "${FILE_NOT_FOUND}"
fi


#Z pliku yolo.csv wypisz wszystkich, których id jest liczbą nieparzystą. Wyniki zapisz na standardowe wyjście błędów. 

1>&2 echo $(cat ${YOLO_FILE} | grep -E "^[0-9]*[1,3,5,7,9]{1}\,")

# Z pliku yolo.csv wypisz każdego, kto jest wart dokładnie $2.99 lub $5.99 lub $9.99. Nie wazne czy milionów, czy miliardów (tylko nazwisko i wartość). Wyniki zapisz na standardowe wyjście błędów 

1>&2 echo $(cat ${YOLO_FILE} | cut -d',' -f3,7 | grep "\$[2|5|9]\.99.$")

#Z pliku yolo.csv wypisz każdy numer IP, który w pierwszym i drugim oktecie ma po jednej cyfrze. Wyniki zapisz na standardowe wyjście błędów

1>&2 echo $(cat ${YOLO_FILE} | cut -d',' -f6 | grep "^[0-9]\.[0-9]\.")

