#!/usr/bin/env bash

# BBTGen | ed.rogers.subs@bristolbraille.co.uk | Begun 11th of Oct, 2016 | GPLv3
# Generate a website using Bash, Markdown and Pandoc.

## Remove old files: N.B. All .htm files outside of ./includes/ are disposable
shopt -s nullglob;
for i in *.htm; do rm $i; done;

## Create navigation menu: define items in ./includes/navbar.txt using Markdown
pandoc -S -t html includes/navbar.txt > includes/navbar.htm;

## Create site-map
for i in *.txt; do 
	j="${i/\.txt/}";
	echo " - [${j^}]($j.htm) ([source]($j.txt))" >> site-map.txt;
done;

## Create main website pages: write pages' sources as .txt files using Markdown
for i in *.txt; do 
	j="${i/\.txt/}";
	pandoc -S -t html "$i" > "$j.temp.htm";
	less includes/header-top.htm includes/navbar.htm includes/header-bottom.htm "$j.temp.htm" includes/footer.htm > "$j.temp2.htm";
	sed "s/<\/title>/ - ${j^}<\/title>/" "$j.temp2.htm" > "$j.htm";
	rm "$j.temp.htm" "$j.temp2.htm";
done;

## Remove temporary files.
rm includes/navbar.htm site-map.txt;

