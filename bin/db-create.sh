#!/usr/bin/env bash

SCHEMA='./etc/schema.sql'

if [[ -z $1 ]]; then
	echo "Usage: $0 <database>" >&2
	exit
fi

# get input, make sane, create, and done
DB=$1
rm -rf $DB
cat $SCHEMA | sqlite3 $DB
exit
