#!/usr/bin/env bash

BATCHES2FILES='./bin/batch2files.sh'
TMP='./tmp'
if [[ -z $1 ]]; then

	echo "Usage: $0 <directory>"
	exit
fi

DIRECTORY=$1
find $TMP -name *.json | parallel $BATCHES2FILES {} "$DIRECTORY"

