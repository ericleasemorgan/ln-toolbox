#!/usr/bin/env bash


# configure
GETCOUNT='./bin/get-count.py'
SEARCH='./bin/search.py'

CLIENTID=''
SECRET=''
QUERY='"Eric Lease Morgan" OR "Roy Tennant"'
START=0
COUNT=50
BATCH=0
DIRECTORY='./batches'

# initialize
rm -rf $DIRECTORY
mkdir -p $DIRECTORY
TOTAL=$( $GETCOUNT $CLIENTID $SECRET "$QUERY" )

# repeat forever
while [ 1 ]; do

	# rest
	sleep 12
	
	# re-configure
	let BATCH=BATCH+1
	OUTPUT=$DIRECTORY/batch-$( printf "%04d" $BATCH ).json
		
	# search
	echo "Getting $COUNT records of $TOTAL starting at record $START ($OUTPUT)" >&2
	$SEARCH $CLIENTID $SECRET "$QUERY" $START $COUNT > $OUTPUT

	# increment and check for done-ness
	let START=START+COUNT
	if [[ $START -gt $TOTAL ]]; then break; fi
	
# fini
done
exit

