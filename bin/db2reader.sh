#!/usr/bin/env bash

QUERY='.mode tabs\nSELECT identifier, content FROM bibliographics;'

if [[ -z $1 || -z $2 ]]; then
	echo "Usage: $0 <database> <output directory>" >&2
	exit
fi

DB=$1
DIRECTORY=$2

IFS=$'\t'
printf "$QUERY" | sqlite3 $DB | while read IDENTIFIER CONTENT; do

	OUTPUT="$DIRECTORY/$IDENTIFIER.xml"
	echo "$CONTENT" > $OUTPUT
		
# fini
done
exit
