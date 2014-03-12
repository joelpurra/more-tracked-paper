#!/bin/bash
set -e

find "$PWD" -name '*.tmp.lyx' -delete

description=$(git describe --tags --always --dirty=-SNAPSHOT)

for lyx in $(find "$PWD" -name '*.lyx');
do
	folder="$(dirname $lyx)"
	base="${lyx%.lyx}"

	echo "Generating $base.lyx $description"

	cd "$folder"

	# Hacky rewrite of .lyx file
	cat "$base.lyx" | sed "s/(Unknown version)/$description/" > "$base.tmp.lyx"
	lyx --force-overwrite --export pdf2 "$base.tmp.lyx" &>/dev/null
	mv "$base.tmp.pdf" "$base.pdf"

	for rmfile in "$base".{aux,log,out,tex,tmp.lyx}; do [[ -s "$rmfile" ]] && rm "$rmfile"; done;

	open "$base.pdf"

	cd - > /dev/null
done

find "$PWD" -name '*.tmp.lyx' -delete