#!/bin/bash
set -e

[[ ! `which git` ]] && { echo "git is required" 1>&2; exit 1; }
[[ ! `which lyx` ]] && { echo "lyx is required" 1>&2; exit 1; }

deleteTmpLyx(){
	find "$PWD" -name '*.tmp.lyx' -delete
}

touchedLyxFileBases=()

deleteAllTmp(){
	local tmpFiles=()

	for touchedLyxFileBase in "${touchedLyxFileBases[@]}"; do
		for rmfile in "$touchedLyxFileBase".{aux,log,out,tex,nlo,toc,lof,lot,synctex,tmp.lyx,tmp.pdf}; do
			[[ -s "$rmfile" ]] && tmpFiles+=("$rmfile");
		done;
	done;

	rm "${tmpFiles[@]}"
}

trap 'deleteAllTmp' EXIT

deleteTmpLyx

description=$(git describe --tags --match 'v[0-9]*' --always --dirty='-SNAPSHOT')
logfile="$(basename "$BASH_SOURCE").log"

echo "Version $description"

for lyx in $(find "$PWD" -name '*.lyx');
do
	folder="$(dirname '$lyx')"
	base="${lyx%.lyx}"

	echo -n "Generating $lyx ... "

	cd "$folder"

	# Hacky rewrite of .lyx file
	cat "$base.lyx" | sed "s/(Unknown~document~version)/$description/" > "$base.tmp.lyx"
	touchedLyxFileBases+=("$base")
	lyx --force-overwrite --export pdf2 "$base.tmp.lyx" &> "$logfile"
	mv "$base.tmp.pdf" "$base.pdf"

	echo "done."

	cd - > /dev/null
done