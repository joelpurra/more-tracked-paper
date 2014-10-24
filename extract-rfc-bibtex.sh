#!/bin/bash
set -e

#
# Usage:
#	cat "../path/to/rfc.bib" "$0" [rfc# [rfc# ...]]
#	Where each RFC is referenced by number only.
#
# Input:
#	A bibtex file with @misc entries with keys "rfc#", where # is a non-padded decimal integer.
#
# Output:
#	Bibtex records for each RFC, in input file RFC order.
#

#
# A bibtex of RFCs (rfc.bib) is available from Dr.-Ing. Roland Bless.
# > BibTeX file of RFC index (converted daily from RFC Editor's XML index)
# http://tm.uka.de/~bless/bibrfcindex.html
#


# From https://github.com/EtiennePerot/parcimonie.sh/blob/master/parcimonie.sh
# Test for GNU `sed`, or use a `sed` fallback in sedExtRegexp
sedExec=(sed)
if [ "$(echo 'abc' | sed -r 's/abc/def/' 2> /dev/null || true)" == 'def' ]; then
	# GNU Linux sed
	sedExec+=(-r)
else
	# Mac OS X sed
	sedExec+=(-E)
fi

sedExtRegexp() {
	"${sedExec[@]}" "$@"
}


getRfcs() {
	local rfcs=$(echo $@ | tr ' ' '|')

	sedExtRegexp -n -e "/^@misc{rfc(${rfcs}),/,/^}\$/ p"
}

cat - | getRfcs "$@"