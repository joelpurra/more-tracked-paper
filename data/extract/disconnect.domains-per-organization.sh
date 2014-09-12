#!/usr/bin/env bash
set -e

setThesisBaseDirs(){
	# TODO: share this function between scripts.
	local projectRoot="$(cd -- "${BASH_SOURCE%/*}"; cd -- "$(git rev-parse --git-dir)/../"; echo "$PWD")"

	# TODO: use http://gitslave.sourceforge.net/ instead?
	local thesisBaseDir="$projectRoot/../"
	local thesisBaseDirAbsolute=$(cd -- "$thesisBaseDir"; echo "$PWD")
	heedlessBaseDir="$thesisBaseDirAbsolute/har-heedless/src"
	dulcifyBaseDir="$thesisBaseDirAbsolute/har-dulcify/src"
}

setThesisBaseDirs

read -d '' mapData <<-'EOF' || true
."domains-per-organization"."group-by-count"
| sort_by(.domains)
EOF

read -d '' renameForTsvColumnOrdering <<-'EOF' || true
map(
	{
		"01--Domains per organization": .domains,
		"02--Organizations": .organizations,
	}
)
EOF

# "prepared.disconnect.services.analysis.json"
cat | jq "$mapData" | jq "$renameForTsvColumnOrdering" | "$dulcifyBaseDir/util/array-of-objects-to-tsv.sh" | "$dulcifyBaseDir/util/clean-tsv-sorted-header.sh"
