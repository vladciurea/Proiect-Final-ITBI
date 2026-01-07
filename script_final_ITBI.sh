#! /bin/bash

file=$1


if [[ ! -f "$file" ]]; then
    echo "Fisierul introdus nu este valid!";
    exit 1
fi

# adaugare \n la inceputul si finalul fiecarui tag
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
tag_style=false
cat temp.txt | while read -r line; do

#rezolvare cazul in care avem un tag script (js) / style (css) in fisier si prezenta caracterelor < > / pot aduce probleme ==> trebuie ignorate

# daca iesim din script/style identam si linia unde se incheie tagul de script

if [[ "$line" == *"</script>"* ]]; then 
	tag_script=false;
fi

if [[ "$line" == *"</style>"* ]]; then
    tag_style=false;
fi

if [[ "$tag_script" = false && "$tag_style" = false ]]; then

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


# verificarea se face la final ca sa identam si linia cu inceputul tagului de script / style

if [[ "$line" == *"<script"* ]]; then 
        tag_script=true;
fi

if [[ "$line" == *"<style"* ]]; then
        tag_style=true;
fi
	
done > $file
