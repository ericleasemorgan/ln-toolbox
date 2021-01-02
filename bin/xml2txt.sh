#!/usr/bin/env bash

# xml2txt.sh - given a input file name and an output directory name, transform an (NITF) XML to plain text
# sample usage: find ../xml -name *.xml -exec ./bin/xml2txt.sh {} /Users/eric/Desktop/txt \;

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 4, 2020 - first investigations


# configure
STYLESHEET='./etc/nitf2txt.xsl'

# sanity check
if [[ ! $1 || ! $2 ]]; then
	echo "Usage: $0 <xml> <output directory>" >&2
	exit
fi

# get input
XML=$1
DIRECTORY=$2

# create output name
BASENAME=$( basename $XML .xml )
OUTPUT="$DIRECTORY/$BASENAME.txt"

# do the work and done
xsltproc $STYLESHEET $XML > $OUTPUT
exit
