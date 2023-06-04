#!/bin/bash
# 
# This script uses the Wild Apricot API to fetch information about upcoming events.
# 
# Uses jq
# See https://stedolan.github.io/jq/
# # WA_key is our API key 
# WA_account is our Wild Apricot account number
# Both are set in .bashrc
# 
# API key must be encoded to base64 with the prefix APIKEY:
# For example, APIKEY:WFVHjqxMsz9k637XCI64bEahTmO7gjv
#
tmp=tmp
getAuth()
{
thisKey=`echo -ne "APIKEY:$WA_key"|base64`
curl -s  --header "Content-Type:application/x-www-form-urlencoded" \
     --header "Authorization: Basic $thisKey" -d "grant_type=client_credentials&scope=auto"\
     https://oauth.wildapricot.org/auth/token  -o token.json
# 
thisAuth=$(jq -r '.access_token' token.json)
#
}
mungFiles ()
{
    #
    while IFS='' read -r eventId || [[ -n "$eventId" ]]; do
	echo "Got this event $eventId"
	curl -s --header "Authorization: Bearer $thisAuth"\
	     'https://api.wildapricot.org/v2.1/accounts/'"$WA_account"'/EventRegistrationTypes?eventId='"$eventId"'' > $eventId.json
	# Need to trap case of missing AvaslableFrom
	
#	jq --raw-output '.[] | [.Id, (.AvailableFrom | strptime("%Y-%m-%dT%H:%M:%S+00:00") | strftime("%m/%d/%y %H:%M") )] | @csv'	$eventId.json >> Id.Time.txt

	read -r Id thisTime  <<<$(jq --raw-output '.[] | [.EventId, (.AvailableFrom | strptime("%Y-%m-%dT%H:%M:%S+00:00") | strftime("%m/%d/%y %H:%M") )] | @sh' $eventId.json)

#	echo $Id $thisTime
	if [ -z "$thisTime" ];
	then
	    echo "No time found"
	else
	       sed -ibak "s|$Id|$thisTime|" Id.Name.csv
	fi
	#jq --compact-output '.[]| .AvailableForMembershipLevels[].Url'      
    done  < $tmp/events.list
}
getMembershipLevels()
{
    curl -s --header "Authorization: Bearer $thisAuth"\
	 https://api.wildapricot.org/v2.2/accounts/204432/MembershipLevels/ |\
	jq '.[] | [.Id, .Name, .MembershipFee] |@sh'
}
#
getAuth
getMembershipLevels
# Build table of events
#jq --raw-output '.Events[] |[ .Id, .Name] | @csv' tmp/events.json > Id.Name.csv
#echo "" > Id.Time.txt

#mungFiles

