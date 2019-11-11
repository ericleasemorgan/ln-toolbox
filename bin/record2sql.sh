#!/usr/bin/env bash

RECORD2SQL='./bin/record2sql.py'

if [[ -z $1 || -z $2 ]]; then
	echo "Usage: $0 <input json> <output directory>" >&2
	exit
fi

FILE=$1
DIRECTORY=$2

# parse out identifier
IDENTIFIER=$( cat $FILE | jq .ResultId )
IDENTIFIER="${IDENTIFIER:1}"
IDENTIFIER="${IDENTIFIER%?}"
IDENTIFIER="$IDENTIFIER:"
IDENTIFIER=$( echo $IDENTIFIER | cut -d ":" -f3 )

# define output, do the work, and done
OUTPUT="$DIRECTORY/insert-$IDENTIFIER.sql"
$RECORD2SQL $FILE > $OUTPUT
exit
