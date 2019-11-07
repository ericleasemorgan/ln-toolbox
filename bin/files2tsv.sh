#!/usr/bin/env bash

# files2tsv.sh - given a list of Lexis/Nexis files (records), output rudimentary bibliographics as TSV

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 7, 2019 - first documentation


# configure
FILE2TSV='./bin/file2tsv.sh'

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <input directory>"
	exit
fi

# get input, initialize output, do the work, and done
DIRECTORY="$1"
printf "identifier\ttitle\tdate\n"
find "$DIRECTORY" -name *.json | parallel $FILE2TSV
exit
