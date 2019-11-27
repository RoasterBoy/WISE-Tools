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
tmp=tmp
getReg=false
eventFilter=""
tagFilter=""
setup ()
{
#
#--------------------------------------------------------- 
# Set up working directory
#
    mkdir -p $tmp
    touch $tmp/tmp.tmp
    rm $tmp/*
#
} # end setup
# 
getAuth()
{
thisKey=`echo -ne "APIKEY:$WA_key"|base64`
curl -s  --header "Content-Type:application/x-www-form-urlencoded" \
     --header "Authorization: Basic $thisKey" -d "grant_type=client_credentials&scope=auto"\
     https://oauth.wildapricot.org/auth/token  -o $tmp/token.json
# 
thisAuth=$(jq -r '.access_token' $tmp/token.json)
#
}
getEvents ()
{
    case $# in
	 0) filterString=""
	    ;;
	 1) filterString="?$filter=$1"
	    ;;
	 2) filterString="?filter=$1 AND $2"
	    ;;
	 *)
	     echo "Bad number of parameters"
    esac
    
curl -s --header "Authorization: Bearer $thisAuth"\
     'https://api.wildapricot.org/v2.1/accounts/'"$WA_account"'/Events'$filterString -o $tmp/events.json
jq '.[] | sort_by(.Name) | .[].Id | rtrimstr(",")' $tmp/events.json > $tmp/events.list
}

#--------------------------------------------------------- 
# Loop through the events and get the details and registrations
#
mungFiles ()
{
#
while IFS='' read -r thisEvent || [[ -n "$thisEvent" ]]; do
#    echo "Got this event $thisEvent"
    if  $getReg ; then
	if [ ! -f $tmp/$thisEvent-registrations.json ]; then
	    curl -s --header "Authorization: Bearer $thisAuth"\
 		 "https://api.wildapricot.org/v2.1/accounts/$WA_account/eventregistrations?eventId=$thisEvent&includeWaitList=true" \
		 -o $tmp/$thisEvent-registrations.json
	    fi
    fi
    if [ ! -f $tmp/$thisEvent-details.json ]; then
	curl -s --header "Authorization: Bearer $thisAuth"  \
	     "https://api.wildapricot.org/v2.1/accounts/$WA_account/events/$thisEvent"\
	     -o $tmp/$thisEvent-details.json
	fi
done  < $tmp/events.list
}
getHelp() {
    printf "%s\n" "Usage:"
    printf "%s\n" "-u Get upcoming events"
    printf "%s\n" "-t Use these tags. Tags must be comma-separated in a quoted string: \"fall,spring\""
    printf "%s\n" "-r Get registration. Default is 'no'."
    printf "%s\n" "-h Prints this message"
    exit
    }
while getopts "ue:t:hr" opt; do
    case ${opt} in
	e ) #get this one event
	    thisEvent=$OPTARG
	    eventFilter='/$thisEvent'
	    ;;
	u ) # Get Upcoming Events
	    echo "Getting upcoming events"
	    eventFilter='IsUpcoming%20eq%20true'
	    ;;
	r ) # Do we need registrations
	    getReg=true
	    ;;
	t ) # Tags
	    tags=$OPTARG
	    tagFilter="Tags%20in%20%5B$tags%5D"
	    ;;
	h) # Print help and exit
	    getHelp
	    ;;
	?)
	    getHelp
	    ;;
	
    esac
done
# 
# 
# 
setup
getAuth
echo "Getting events, putting details in $tmp"
getEvents $tagFilter $eventFilter
if [ $getReg = "true" ]; then
   mungFiles
   fi 
