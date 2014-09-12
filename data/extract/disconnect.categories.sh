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
def lookupMap(from; to):
	(from | explode) as $from
	| (to | explode) as $to
	| ($from | length) as $length
	| reduce range(0; $length) as $index (
		{};
		($from[$index:$index + 1] | implode) as $fromChar
		| ($to[$index:$index + 1] | implode) as $toChar
		| .[$fromChar] = $toChar
	);

def mapOrSameCharacter(lookupMap):
	. as $char
	| lookupMap as $lookupMap
	| if ($lookupMap | has($char)) then
		$lookupMap[$char]
	else
		$char
	end;

def stringToChars:
	explode
	| map([ . ] | implode);

def charsToString:
	join("");

def mapOrSame(lookupMap):
	lookupMap as $lookupMap
	| stringToChars
	| map(mapOrSameCharacter($lookupMap))
	| charsToString;

def toUppercase:
	lookupMap("abcdefghijklmnopqrstuvwxyz"; "ABCDEFGHIJKLMNOPQRSTUVWXYZ") as $alphabetLookupMap
	| mapOrSame($alphabetLookupMap);

def toLowercase:
	lookupMap("ABCDEFGHIJKLMNOPQRSTUVWXYZ"; "abcdefghijklmnopqrstuvwxyz") as $alphabetLookupMap
	| mapOrSame($alphabetLookupMap);

def sort_by_string_caseinsensitive(property):
	# Caches the converted { sortable: (property | toLowercase), value: . } for speedups?
	sort_by(property | toLowercase);

. as $root
| $root."domains-per-category"
| with_entries(
	.value |= {
		"domains-per-category": .
	}
)
| . * (
	$root."organizations-per-category".count
	| with_entries(
		.value |= {
			"organizations-per-category": .
		}
	)
)
| to_entries
| sort_by_string_caseinsensitive(.key)
EOF

read -d '' renameForTsvColumnOrdering <<-'EOF' || true
map(
	{
		"01--Category": .key,
		"02--Domains": .value."domains-per-category",
		"03--Organizations": .value."organizations-per-category",
	}
)
EOF

# "prepared.disconnect.services.analysis.json"
cat | jq "$mapData" | jq "$renameForTsvColumnOrdering" | "$dulcifyBaseDir/util/array-of-objects-to-tsv.sh" | "$dulcifyBaseDir/util/clean-tsv-sorted-header.sh"
