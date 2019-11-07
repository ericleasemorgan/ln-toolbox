#!/usr/bin/env bash

# file2tsv.sh - given a Lexis/Nexis JSON file (record), output rudimentary bibliographics

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 6, 2019 - first cut


# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <json>" >&2
	exit
fi

# get input
JSON=$1

# parse out the record
TITLE=$( cat $JSON | jq .Title )
DATE=$( cat $JSON | jq .Date )
	
# normalize the bibliographics
TITLE="${TITLE:1}"
TITLE="${TITLE%?}"
DATE="${DATE:1}"
DATE="${DATE%?}"
DATE=$( echo $DATE | cut -d "T" -f1 )

# output and done
printf "$TITLE\t$DATE\n"
exit