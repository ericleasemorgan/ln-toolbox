#!/usr/bin/env bash

# search.sh - given a few pre-configurations, query Lexis/Nexis and output results as a set of files

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 7, 2019 - first documentation, but based on previous work; need to remove pre-configurations


# pre-configure
CLIENTID='34PWFMDK6DT3GCQ8D77JK7W22WTGK5'
SECRET='WXN8H2QPVTKFTJ62Q3RQBJ4H83JGJQJ26SSGHJ6C'
QUERY='((TICKER("MS (NYSE)") OR COMPANY (Morgan Stanley)) AND (DATE > 1999 AND DATE < 2020)'

# configure
GETCOUNT='./bin/get-count.py'
BATCH2FILES='./bin/batch2files.sh'
SEARCH='./bin/search.py'
START=0
COUNT=50
BATCH=0
TMP='./tmp'

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <output directory>" >&2
	exit
fi

# get input
DIRECTORY=$1

# initialize
TOTAL=$( $GETCOUNT $CLIENTID $SECRET "$QUERY" )
echo "Total number of hits: $TOTAL" >&2

# make sane
rm -rf $TMP
mkdir -p $TMP

# repeat forever; search
while [ 1 ]; do

	# rest
	sleep 12
	
	# re-configure
	let BATCH=BATCH+1
	OUTPUT=$TMP/batch-$( printf "%04d" $BATCH ).json
		
	# do the work
	echo "Getting $COUNT records of $TOTAL starting at record $START ($OUTPUT)" >&2
	$SEARCH $CLIENTID $SECRET "$QUERY" $START $COUNT > $OUTPUT

	# parse results into files
	$BATCH2FILES "$OUTPUT" "$DIRECTORY" &
	
	# increment and done, conditionally
	let START=START+COUNT
	if [[ $START -gt $TOTAL ]]; then break; fi
	#if [[ $START -gt $LIMIT ]]; then break; fi
	
# fini
done
wait
exit

