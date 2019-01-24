#!/bin/bash
# 
# This script uses the Wild Apricot API to fetch information about upcoming events.
# 
# Uses jq
# See https://stedolan.github.io/jq/
# 
# WA_key is our API key 
# WA_account is our Wild Apricot account number
# Both are set in .bashrc
# 
# API key must be encoded to base64 with the prefix APIKEY:
# For example, APIKEY:WFVHjqxMsz9k637XCI64bEahTmO7gjv
# 
thisKey=`echo -ne "APIKEY:$WA_key"|base64`
# 
#--------------------------------------------------------- 
# Set up working directory
#
rm -r working 
mkdir -p working
cd working
# 
curl -s  --header "Content-Type:application/x-www-form-urlencoded" \
     --header "Authorization: Basic $thisKey" -d "grant_type=client_credentials&scope=auto"\
     https://oauth.wildapricot.org/auth/token  -o token.json
# 
thisAuth=$(jq -r '.access_token' token.json)
curl -s --header "Authorization: Bearer $thisAuth"\
     'https://api.wildapricot.org/v2.1/accounts/'"$WA_account"'/Events?$filter=IsUpcoming%20eq%20true' \
     | jq '.Events[].Id | rtrimstr(",")' > events.list
#
#--------------------------------------------------------- 
# Loop through the events and get the details and registrations
#
while IFS='' read -r thisEvent || [[ -n "$thisEvent" ]]; do

    curl --header "Authorization: Bearer $thisAuth" \
	 "https://api.wildapricot.org/v2.1/accounts/$WA_account/eventregistrations?eventId=$thisEvent&includeWaitList=true"\
	 -o $thisEvent-registrations.json
    curl --header "Authorization: Bearer $thisAuth" \
	 "https://api.wildapricot.org/v2.1/accounts/$WA_account/events/$thisEvent" \
	 -o $thisEvent-details.json
done < events.list
