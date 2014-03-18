#!/bin/bash
set -e

[[ ! `which git` ]] && echo "git is required"
[[ ! `which lyx` ]] && echo "lyx is required"

deleteTmpLyx(){
	find "$PWD" -name '*.tmp.lyx' -delete
}

deleteTmpLyx

description=$(git describe --tags --match 'v[0-9]*' --always --dirty='-SNAPSHOT')

echo "Version $description"

for lyx in $(find "$PWD" -name '*.lyx');
do
	folder="$(dirname '$lyx')"
	base="${lyx%.lyx}"

	echo "Generating $base.lyx"

	cd "$folder"

	# Hacky rewrite of .lyx file
	cat "$base.lyx" | sed "s/(Unknown version)/$description/" > "$base.tmp.lyx"
	lyx --force-overwrite --export pdf2 "$base.tmp.lyx" &>/dev/null
	mv "$base.tmp.pdf" "$base.pdf"

	for rmfile in "$base".{aux,log,out,tex,tmp.lyx}; do [[ -s "$rmfile" ]] && rm "$rmfile"; done;

	cd - > /dev/null
done

deleteTmpLyx