#!/bin/bash -eu

FILE_NOT_FOUND=10

ACCESS_LOG_FILE="./access_log"

if [[ ! -f ${ACCESS_LOG_FILE} ]]; then
    echo "File not found"
    exit "${FILE_NOT_FOUND}"
fi

# Znajdź w pliku access_log zapytania, które mają frazę "denied" w linku
cat ${ACCESS_LOG_FILE} | grep "GET" | grep "denied" > denied.txt

# Znajdź w pliku access_log zapytania typu POST
cat ${ACCESS_LOG_FILE} | grep "POST /" > post.txt

#Znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
cat ${ACCESS_LOG_FILE} | grep "^64.242.88.10 " > ip.txt

#Znajdź w pliku access_log wszystkie zapytania NIEWYSŁANE z adresu IP tylko z FQDN
cat ${ACCESS_LOG_FILE} | grep -E -v "^[0-9][0-9]?[0-9]?\." > fqdn.txt

#Znajdź w pliku access_log unikalne zapytania typu DELETE
cat ${ACCESS_LOG_FILE} | grep "DELETE /" | sort -u > delete.txt

#Znajdź unikalnych 10 adresów IP w access_log
cat ${ACCESS_LOG_FILE} | grep -E -o "^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?" | sort -u | head -n 10 > 10IP.txt
