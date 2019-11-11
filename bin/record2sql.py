#!/usr/bin/env python

# record2sql.py - given a Lexis/Nexis JSON file (record), output bibliographics in the form of an SQL statement


# configure
TEMPLATE = "INSERT INTO bibliographics ( 'identifier', 'author', 'title', 'date', 'year', 'month', 'day', 'source', 'content' ) VALUES ( '##IDENTIFIER##', '##AUTHOR##', '##TITLE##', '##DATE##', '##YEAR##', '##MONTH##', '##DAY##', '##SOURCE##', '##CONTENT##' );"

# require
import json
import sys
import re

# output to stderr
def warn ( m ) :
	m = m + '\n'
	sys.stderr.write( m )

# sanity check
if len( sys.argv ) != 2 :
	warn( 'Usage: ' + sys.argv[ 0 ] + " <file>" )
	quit()

# get input
file = sys.argv[ 1 ]

# slurp up the data
with open( file ) as handle : data = json.load( handle )

# parse
identifier = data[ 'ResultId' ].split( ':' )[ 2 ]
author     = data[ 'Byline' ] if data[ 'Byline' ] else ''
title      = data[ 'Title' ]
date       = data[ 'Date' ].split( "T" )[ 0 ]
source     = data[ 'Source' ]['Name']
content    = data[ 'Document' ]['Content']

# parse some more
year  = date.split( '-' )[ 0 ]
month = date.split( '-' )[ 1 ]
day   = date.split( '-' )[ 2 ]

# normalize
month = re.sub( "^0", '', month )

# debug
warn( '  identifier: ' + identifier )
warn( '      author: ' + author )
warn( '       title: ' + title )
warn( '        date: ' + date )
warn( '        year: ' + year )
warn( '       month: ' + month )
warn( '         day: ' + day )
warn( '      source: ' + source )

# escape
author  = re.sub( "'", "''", author )
title   = re.sub( "'", "''", title )
content = re.sub( "'", "''", content )
source  = re.sub( "'", "''", source )

# build sql
sql = TEMPLATE
sql = re.sub( "##IDENTIFIER##", identifier, sql )
sql = re.sub( "##AUTHOR##", author, sql )
sql = re.sub( "##TITLE##", title, sql )
sql = re.sub( "##DATE##", date, sql )
sql = re.sub( "##YEAR##", year, sql )
sql = re.sub( "##MONTH##", month, sql )
sql = re.sub( "##DAY##", day, sql )
sql = re.sub( "##SOURCE##", source, sql )
sql = re.sub( "##CONTENT##", content, sql )

# output
print( sql )

# done
exit()
