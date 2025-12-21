#! /bin/bash

file=$1

if [[ ! -f "$file" ]] then
    echo "Te rog introdu un fisier valid";
    exit 1
fi


sed -i "s/>/>\n/g" "$file" 
