#!/usr/bin/env python

# search.py - given quite a few inputs, query Lexis Nexis and output results

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# October 16, 2019 - first documentation; based on work provided by Jeff Clark <jeff.clark.1@lexisnexis.com>
# October 21, 2019 - implemented command-line input
# November 7, 2019 - simplified, but needs a whole lot of cleaning!


# advanced configuration
CONTENT  = 'News'
#FILTER   = "SearchType eq LexisNexis.ServicesApi.SearchType'Boolean' and PublicationType eq 'TmV3c3BhcGVycw' and GroupDuplicates eq LexisNexis.ServicesApi.GroupDuplicates'ModerateSimilarity' and Language eq LexisNexis.ServicesApi.Language'English'"
FILTER   = "SearchType eq LexisNexis.ServicesApi.SearchType'Boolean' and GroupDuplicates eq LexisNexis.ServicesApi.GroupDuplicates'ModerateSimilarity' and Language eq LexisNexis.ServicesApi.Language'English' and Source/Id eq 'MTA1MjUxNA'"

# require
from datetime import datetime 
from requests.auth import HTTPBasicAuth
from time import sleep
import json
import requests
import sys

# sanity check
if len( sys.argv ) != 6 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <client id> <secret> <query> <offset> <count>\n" )
	quit()

# get input
CLIENTID = sys.argv[ 1 ]
SECRET   = sys.argv[ 2 ]
QUERY    = sys.argv[ 3 ]
offset   = int( sys.argv[ 4 ] )
count    = int( sys.argv[ 5 ] )

# declare
def get_token( client_id, secret ) :
    """Gets Authorizaton token to use in other requests."""
    auth_url  = 'https://auth-api.lexisnexis.com/oauth/v2/token'
    payload   = ( 'grant_type=client_credentials&scope=http%3a%2f%2f' 'oauth.lexisnexis.com%2fall' )
    headers   = { 'Content-Type': 'application/x-www-form-urlencoded' }
    r         = requests.post( auth_url, auth=HTTPBasicAuth( client_id, secret ), headers=headers, data=payload )
    json_data = r.json()
    return json_data[ 'access_token' ]

def build_header( token ) : 
    """Builds the headers part of the request to Web Services API."""
    headers = { 'Accept': 'application/json;odata.metadata=minimal', 'Connection': 'Keep-Alive', 'Host': 'services-api.lexisnexis.com' }
    headers[ 'Authorization' ] = 'Bearer ' + token
    return headers

def build_url( content='News', query='', skip=0, expand='Document', top=50, filter=None ) :
	"""Builds the URL part of the request to Web Services API."""
	# check for filter
	if filter != None :
		api_url = ('https://services-api.lexisnexis.com/v1/' + content + '?$expand=' + expand + '&$search=' + query + '&$skip=' + str(skip) + '&$top=' + str(count) + '&$filter=' + filter )
	else : api_url = ('https://services-api.lexisnexis.com/v1/' + content + '?$expand=' + expand + '&$search=' + query + '&$skip=' + str(skip) + '&$top=' + str(count))
	return api_url

# initialize
headers = build_header( get_token( CLIENTID, SECRET ) )

# Filter is set to filter=None here. Change to filter=filter to use the filter specified above
url      = build_url( content=CONTENT, query=QUERY, skip=offset, expand='Document', top=count, filter=FILTER )  
response = requests.get( url, headers=headers )

# Creates a file with the current time as the file name.
print( response.text )
