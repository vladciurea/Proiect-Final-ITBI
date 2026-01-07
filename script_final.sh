#! /bin/bash

file=$1


if [[ ! -f "$file" ]]; then
    echo "Te rog introdu un fisier valid";
    exit 1
fi

# adaugare \n intre taguri
sed -i "s/>/>\n/g" "$file" 
sed -i "s/</\n</g" "$file"

# stergere randuri goale
cat $file | while read -r line; do
    if [[ -n "$line" ]] then
        echo "$line"
    fi
done > temp.txt




t_cnt=0
tag_script=false
cat temp.txt | while read -r line; do

#rezolvare cazul in care avem un script in html si prezenta caracterelor < > / pot aduce probleme ==> trebuie ignorate

# daca iesim din script identam si linia unde se incheie tagul de script
if [[ "$line" == *"</script>"* ]]; then 
	tag_script=false;
fi


if [[ "$tag_script" = false ]]; then

	case "${line:0:2}" in
        	"</") ((t_cnt--)) ;;
		esac

	#for ul pentru identarea liniilor
	for ((i=0; i<t_cnt; i++)); do   
		printf '\t'; 
        	done
       		echo "$line"


	case "${line:0:4}" in
		"<!"*) ;;
		"<met"*);; #meta charset...
		"<lin"*);; #link href ...
		"<img"*);; #img src ....
		"</"*);; # am scazut deja contorul taburilor la case ul anterior
       		 "<"*) 
			((t_cnt++));;
	esac
else # tag_script  = true
	echo "$line"
fi


# verificarea se face la final ca sa identam si linia cu inceputul tagului de script

if [[ "$line" == *"<script"* ]]; then 
        tag_script=true;
fi



	
done > $file
