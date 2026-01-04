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

	if [[ "$line" == *"<!"* ]]; then
   		 echo "aici e comentariu"
	fi

done > temp.txt

mv temp.txt $file
