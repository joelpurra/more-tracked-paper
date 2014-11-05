#!/bin/bash
set -e

[[ ! `which git` ]] && { echo "git is required" 1>&2; exit 1; }
[[ ! `which lyx` ]] && { echo "lyx is required" 1>&2; exit 1; }

deleteGeneratedTmpFiles(){
	find "$PWD" -name '.generated.version' -delete
}

touchedLyxFileBases=()

deleteAllTmp(){
	deleteGeneratedTmpFiles

	local tmpFiles=()

	for touchedLyxFileBase in "${touchedLyxFileBases[@]}"; do
		for rmfile in "$touchedLyxFileBase".{aux,log,out,tex,nlo,toc,lof,lot,synctex}; do
			[[ -s "$rmfile" ]] && tmpFiles+=("$rmfile");
		done;
	done;

	(( "${#tmpFiles[@]}" > 0 )) && rm "${tmpFiles[@]}"
}

trap 'deleteAllTmp' EXIT

deleteGeneratedTmpFiles

description=$(git describe --tags --match 'v[0-9]*' --always --dirty='-SNAPSHOT')
logfile="$(basename "$BASH_SOURCE").log"

echo "Version $description"

for lyx in $(find "$PWD" -name '*.lyx');
do
	folder="$(dirname "$lyx")"
	base="${lyx%.lyx}"

	echo -n "Generating $lyx ... "

	pushd "$folder" > /dev/null
	echo "$description" > ".generated.version"

	touchedLyxFileBases+=("$base")
	lyx --force-overwrite --export pdf2 "$lyx" &> "$logfile"

	echo "done."

	popd > /dev/null
done