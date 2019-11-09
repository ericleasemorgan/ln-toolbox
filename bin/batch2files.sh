#!/usr/bin/env bash

# batch2files.sh - given a batch of Lexis/Nexis records, out each record as a file

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 6, 2019 - first cut


# sanity check
if [[ -z $1 || -z $2 ]]; then
	echo "Usage: $0 <json> <directory>" >&2
	exit
fi

# get input
JSON=$1
DIRECTORY=$2

# make sane
mkdir -p $DIRECTORY

# calculate the length of this batch
LENGTH=$( cat $JSON | jq ".value | length" )

# read the batch item by item
for (( I=0; I<$LENGTH; I+=1 )); do

	# parse out the record
	RECORD=$( cat $JSON | jq ".value[ $I ]" )
	
	# parse out the identifier (urn)
	IDENTIFIER=$( echo $RECORD | jq '.ResultId' )
	IDENTIFIER="${IDENTIFIER:1}"
	IDENTIFIER="${IDENTIFIER%?}"
	IDENTIFIER="$IDENTIFIER:"
	IDENTIFIER=$( echo $IDENTIFIER | cut -d ':' -f3 )

	# increment and build output filename
	INDEX=$(( INDEX+1 ))
	OUTPUT="$DIRECTORY/record-$IDENTIFIER.json"

	# output
	echo "$RECORD" > $OUTPUT
	
# fini
done
exit
