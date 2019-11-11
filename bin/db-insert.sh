#!/usr/bin/env bash

SQL='./tmp/inserts.sql'

if [[ -z $1 || -z $2 ]]; then
	echo "Usage: $0 <input directory> <db file>" >&2
	exit
fi

# get input
DIRECTORY=$1
DB=$2

# build sql, do the work, and done
echo 'BEGIN TRANSACTION;' > $SQL
cat $DIRECTORY/*.sql >> $SQL
echo 'END TRANSACTION;' >> $SQL
cat $SQL | sqlite3 $DB
exit
