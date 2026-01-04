#! /bin/bash

file=$1

if [[ ! -f "$file" ]] then
    echo "Te rog introdu un fisier valid";
    exit 1
fi


sed -i "s/>/>\n/g" "$file" 
sed -i "s/</\n</g" "$file"

cat $file | while read -r line; do
    if [[ -n "$line" ]] then
        echo "$line"
    fi
done > temp.txt

t_cnt=0
cat $file | while read -r line; do
    case "${line:0:2}" in
        "<!") ;;
        "</") ((t_cnt--)) ;;
        "<"*) ((t_cnt++)) ;;
        *) ;;
    esac
    ct_cnt=t_cnt
    
done


mv temp.txt $file

