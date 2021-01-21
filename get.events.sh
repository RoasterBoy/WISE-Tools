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
### get.events - get Wild Apricot events
###
### Usage:
###   get.events.sh [options]
###
### Options:
start_time="$(date -u +%s)"
tmp=~/tmp/wa
outdir=~/tmp/out
getReg=false
eventFilter=""
tagFilter=""


help()
{
    thisScript=$(which "$0")
    sed -rn 's/^\s*### ?//;T;p' "$thisScript"
    exit
    }
msg()
{
    if [  "$verbose" = true ];
    then
	msgString=$*
	echo "%% $msgString"
    fi
}
setup ()
{
#
#--------------------------------------------------------- 
# Set up working directory
#
    mkdir -p $tmp
    touch $tmp/tmp.tmp
    rm -r $tmp/*
    mkdir -p $outdir
    touch $outdir/tmp.tmp
    rm $outdir/*
##
# 
# end setup
}
getAuth()
{
    thisAuth=$(get.auth.sh)
}
getEvents ()
{
    case $# in
	 0) filterString=""
	    ;;
	 1) filterString="?\$filter=$1"
	    ;;
	 2) filterString="?\$filter=$1 AND $2"
	    ;;
	 *)
	     echo "Bad number of parameters"
    esac
curl -s --header "Authorization: Bearer $thisAuth"\
     'https://api.wildapricot.org/v2.2/accounts/'"$WA_account"'/Events'"$filterString" -o $tmp/events.json
jq '.[] | sort_by(.Id) | .[].Id | rtrimstr(",")' $tmp/events.json > $tmp/events.list
msg "Events information is in $tmp/events.json"
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
	if [ ! -f $tmp/$thisEvent.registrations.json ]; then
	    curl -s --header "Authorization: Bearer $thisAuth"\
 		 "https://api.wildapricot.org/v2.2/accounts/$WA_account/eventregistrations?eventId=$thisEvent&includeWaitList=true" \
		 -o $tmp/$thisEvent.registrations.json
	fi
#	jq --raw-output '.[] | [.Event.Id,.Contact.Id, .OnWaitlist] | @tsv' $tmp/$thisEvent.registrations.json > $outdir/$thisEvent-registration.tsv
    fi
    if [ ! -f $tmp/$thisEvent.details.json ]; then
	curl -s --header "Authorization: Bearer $thisAuth"  \
	     "https://api.wildapricot.org/v2.2/accounts/$WA_account/events/$thisEvent"\
	     -o $tmp/$thisEvent.details.json
	# TODO Not sure why this file might not exist
	# TODO If we stored this stuff in a database, we could just update as needed.
	if [ -e $tmp/$thisEvent.details.json ]
	then
	    thisName=$(jq '.Name' $tmp/$thisEvent.details.json)
	fi
	msg "Working on $thisName"
	fi
done  < $tmp/events.list
}
getSingle()
{
curl -s --header "Authorization: Bearer $thisAuth"\
     'https://api.wildapricot.org/v2.2/accounts/'"$WA_account"'/Events/'$eventId -o $tmp/$eventId.json
}

while getopts "ue:s:t:hvr" opt; do
    case ${opt} in
	e ) #get this one event
	    ### -e Get single event eventId
	    eventId=$OPTARG
	    ;;
	u ) # Get Upcoming Events
	    ### -u Get upcoming events
	    echo "Getting upcoming events"
	    eventFilter='IsUpcoming%20eq%20true'
	    ;;

	r ) # Do we need registrations
	    ### -r Get registration. Default is 'no'.
	    getReg=true
	    ;;
	t ) # Tags
	    ### -t Use these tags. Tags must be comma-separated in a quoted string: \"fall,spring\"
	    tags=$OPTARG
	    tagFilter="Tags%20in%20%5B$tags%5D"
	    ;;
	v ) #Verbose
	    ### -v Verbose mode
	    verbose=true
	    ;;
	h) # Print help and exit
	    ### -h Prints this message
	    help
	    ;;
	?)
	    help
	    ;;
	
    esac
done
# 
# 
# 
setup
getAuth
msg "Getting events, putting details in $tmp"
if [ -z ${eventId} ]; then
    getEvents $tagFilter $eventFilter
    if [ $getReg = "true" ]; then
	mungFiles
    fi 
else
    getSingle $eventId
fi
end_time=$(date -u +%s)
elapsed=$((end_time-start_time))
msg "Elapsed time: $elapsed seconds"
