#!/usr/bin/env bash


# pre-configure
CLIENTID=''
SECRET=''
QUERY='"Eric Lease Morgan"'

# configure
GETCOUNT='./bin/get-count.py'
SEARCH='./bin/search.py'
START=0
COUNT=50
BATCH=0
TMP='./tmp'

# initialize
rm -rf $TMP
mkdir -p $TMP
TOTAL=$( $GETCOUNT $CLIENTID $SECRET "$QUERY" )

# repeat forever
while [ 1 ]; do

	# rest
	sleep 12
	
	# re-configure
	let BATCH=BATCH+1
	OUTPUT=$TMP/batch-$( printf "%04d" $BATCH ).json
		
	# search
	echo "Getting $COUNT records of $TOTAL starting at record $START ($OUTPUT)" >&2
	$SEARCH $CLIENTID $SECRET "$QUERY" $START $COUNT > $OUTPUT

	# increment and check for done-ness
	let START=START+COUNT
	if [[ $START -gt $TOTAL ]]; then break; fi
	
# fini
done

exit

