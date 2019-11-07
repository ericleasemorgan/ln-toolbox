#!/usr/bin/env bash

# batches2files.sh - given a list of Lexis/Nexis batch files, output each record as a file

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 7, 2019 - first documentation


# configure
BATCH2FILES='./bin/batch2files.sh'
TMP='./tmp'

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <directory>"
	exit
fi

# get input, do the work, and done
DIRECTORY=$1
find $TMP -name *.json | parallel $BATCH2FILES {} "$DIRECTORY"
exit

