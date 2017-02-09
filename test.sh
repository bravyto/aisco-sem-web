#!/bin/bash

echo '' > src/install/z_install_data.erl;
cat src/install/z_install_data_base > src/install/z_install_data.erl;

class=($(xml_grep 'owl:Class' charity_org_rdf.owl | grep -oP 'rdf:about="[a-z,A-Z,0-9,:,/,.,-]*#\K[^"]*'))
classlink=($(grep -oP 'owl:Class rdf:about="\K[^"]*' charity_org_rdf.owl))
rangesubclasslink=($(xml_grep 'rdfs:subClassOf' charity_org_rdf.owl | grep -oP 'rdf:resource="\K[^"]*'))

counter=0;
for i in `seq 0 $[${#class[@]}-1]`; do  
	link=($(echo ${classlink[$i]} | sed 's./.\\/.g')); 
	temp=($(sed -n '/<owl:Class rdf:about="'$link'">/,/<\/owl:Class>/p' charity_org_rdf.owl));
	if [[ -n "$temp" ]]; then 
		temp=($(sed -n '/<owl:Class rdf:about="'$link'"/,/<\/owl:Class>/p' charity_org_rdf.owl | xml_grep 'rdfs:subClassOf'));
		if [[ -n "$temp" ]]; then 
			domainsubclasslink[$counter]=${classlink[$i]};
			parent[$i]=${rangesubclasslink[$counter]}
			counter=$[1+$counter];
		fi;
	fi; 
done;

function checkchild {
	for k in "${!parent[@]}"; do 
		if [[ $1 = ${parent[$k]} ]]; then
			depth[$k]=$[${depth[$k]}+1];
			checkchild ${classlink[$k]};
		fi
	done
}


for i in "${!domainsubclasslink[@]}"; do 
	for j in "${!classlink[@]}"; do 
		if [[ ${domainsubclasslink[$i]} = ${classlink[$j]} ]]; then 
			for k in "${!classlink[@]}"; do 
				if [[ ${rangesubclasslink[$i]} = ${classlink[$k]} ]]; then
					depth[$j]=$[${depth[$k]}+1];
					checkchild ${classlink[$j]};
				fi
			done
		fi 
	done 
done

function countchild {
	for k in "${!parent[@]}"; do 
		if [[ $1 = ${parent[$k]} ]]; then
			totalchild[$2]=$[${totalchild[$2]}+1];
			countchild ${classlink[$k]} $2;
		fi
	done
}

for i in `seq 0 $[${#classlink[@]}-1]`; do  
	countchild ${classlink[$i]} $i;
done;

function printchild {
	for k in "${!parent[@]}"; do 
		if [[ $1 = ${parent[$k]} ]]; then
			x=$[124+$counter];
			y=$[19+$counter];
			if [[ ${totalchild[$k]} > 0 ]]; then
				z=$[19+$counter+${totalchild[$k]}]; 
			else
				z=$y;
			fi;
			if [[ "${class[$k],,}" != 'person' ]]; then 
				new=$new,\{$x,$2,$y,1,$y,$z,${class[$k],,},false,\"${classlink[$k]}\",\[\{title,\{trans,\[\{en,\<\<\"${class[$k]}\"\>\>\}\]\}\}\]\};
				erlid[$k]=$x;
				counter=$[1+$counter]; 
			fi;
			printchild ${classlink[$k]} $x;
		fi
	done
}

new=\{nl,\<\<\"Predikaat\"\>\>\}\]\}\}\]\}
counter=0;
for i in `seq 0 $[${#class[@]}-1]`; do
	if [[ ${depth[$i]} < 1 ]]; then
		x=$[124+$counter];
		y=$[19+$counter];
		if [[ ${totalchild[$i]} > 0 ]]; then
			z=$[19+$counter+${totalchild[$i]}]; 
		else
			z=$y;
		fi;
		if [[ "${class[$i],,}" != 'person' ]]; then 
			new=$new,\{$x,undefined,$y,1,$y,$z,${class[$i],,},false,\"${classlink[$i]}\",\[\{title,\{trans,\[\{en,\<\<\"${class[$i]}\"\>\>\}\]\}\}\]\}; 
			erlid[$i]=$x;
			counter=$[1+$counter];
		fi;
		printchild ${classlink[$i]} $x;
	fi; 
done

echo $new;