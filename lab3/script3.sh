#!/bin/bash -eu

DIR_NOT_FOUND=53

GROOVIES_PATH="groovies"

if [[ ! -d ${GROOVIES_PATH} ]]; then
    echo "Dir not found"
    exit "${DIR_NOT_FOUND}"
fi

cd ${GROOVIES_PATH}

#We wszystkich plikach w katalogu ‘groovies’ zamień $HEADER$ na /temat/

sed 's|\$HEADER\$|\/temat\/|g' two.groovy > two_s.txt

sed 's|\$HEADER\$|\/temat\/|g' one.groovy > one_s.txt

#We wszystkich plikach w katalogu ‘groovies’ po każdej linijce z 'class' dodać ' String marker = '/!@$%/''

sed  '/class/a\ String marker = /!@$%/' one.groovy > one_a.txt

sed  '/class/a\ String marker = /!@$%/' two.groovy > two_a.txt

#We wszystkich plikach w katalogu ‘groovies’ usuń linijki zawierające frazę 'Help docs:'

sed '/Help docs/d' one.groovy > one_d.txt

sed '/Help docs/d' two.groovy > two_d.txt


