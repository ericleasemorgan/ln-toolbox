#!/usr/bin/env bash

FILE2TSV='./bin/file2tsv.sh'

if [[ -z $1 ]]; then

	echo "Usage: $0 <directory>"
	exit
fi

DIRECTORY="$1"
printf "identifier\ttitle\tdate\n"
find "$DIRECTORY" -name *.json | parallel $FILE2TSV

