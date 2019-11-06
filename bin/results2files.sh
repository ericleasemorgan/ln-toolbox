#!/usr/bin/env bash

# results2files.sh - given a Lexis/Nexis Web Services API JSON, cache entry values to files

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# October 21, 2019 - first documentation


# configure
BATCHES='./batches'
RECORDS='./records'

# initialize and make sane
mkdir -p $RECORDS
INDEX=0

# process each item in the result
cat $JSON | jq .ResultId | while read ENTRY; do

	# remove leading and trailing quote marks; cool!
	ENTRY="${ENTRY:1}"
	ENTRY="${ENTRY%?}"
	
	# increment and build output filename
	INDEX=$(( INDEX+1 ))
	FILE="$CORPUS/entry-$( printf '%03d' $INDEX ).xml"
	
	# output
	echo $ENTRY > $FILE
	
# fini
done
exit
