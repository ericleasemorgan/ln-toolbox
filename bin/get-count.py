#!/usr/bin/env python

# get-count.py - given a client id, client secret, and query, return the number of items match the query

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# November 6, 2019 - first cut; needs to be cleaned up


# configure
CONTENT = 'News'
FILTER   = "SearchType eq LexisNexis.ServicesApi.SearchType'Boolean' and GroupDuplicates eq LexisNexis.ServicesApi.GroupDuplicates'ModerateSimilarity' and Language eq LexisNexis.ServicesApi.Language'English' and Source/Id eq 'MTA1MjUxNA'"

# require
from requests.auth import HTTPBasicAuth
import json
import requests
import sys

# sanity check
if len( sys.argv ) != 4 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <client id> <secret> <query>\n" )
	quit()

# get input
CLIENTID = sys.argv[ 1 ]
SECRET   = sys.argv[ 2 ]
QUERY    = sys.argv[ 3 ]

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
	if filter != None : api_url = ('https://services-api.lexisnexis.com/v1/' + content + '?$expand=' + expand + '&$search=' + query + '&$skip=' + str(skip) + '&$top=1&$filter=' + filter )
	else : api_url = ('https://services-api.lexisnexis.com/v1/' + content + '?$expand=' + expand + '&$search=' + query + '&$skip=0' + '&$top=1')
	return api_url

def get_result_count(json_data) :
    """Gets the number of results from @odata.count in the response"""
    return json_data[ '@odata.count' ]

# initialize
headers = build_header( get_token( CLIENTID, SECRET ) )

# Filter is set to filter=None here. Change to filter=filter to use the filter specified above
url      = build_url( content=CONTENT, query=QUERY, skip=0, expand='Document', top=1, filter=FILTER )  
response = requests.get( url, headers=headers )

# Creates a file with the current time as the file name.
print( str( get_result_count( response.json() ) ) )


