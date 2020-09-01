#!/bin/bash
#
### get.zoom.meetings.sh - get meetings for one or more Zoom hosts
###
### Usage:
###   get.zoom.meetings.sh hosts.list.txt [options]
### 
###   hosts.list.txt comes from get.zoom.hosts.sh
### TODO Do host.list.txt and hosts.json exist?
###
### Options:
help()
{
    thisScript=$(which "$0")
    sed -rn 's/^### ?//;T;p' "$thisScript"
    exit
}
thisAuth=$(python3 $tools/get.auth.py)
msg()
{
    if [  "$verbose" = true ];
    then
	# echo "Verbose is $verbose"
	thisString=$@
	echo "%% $thisString"
    fi
}
setup()
{
    thisList=hosts.list.txt
    thisJSON=hosts.json
    msg "Host list is $thisList"
    msg "JSON file is $thisJSON"
    tmp=/tmp/zoom
    mkdir -p $tmp
    touch $tmp/tmp.tmp
    rm -r $tmp/*
    : > zoom.events.html
    echo "<!-- Created by $(which "$0") on $(date) -->" > zoom.events.html
}
getMeetings()
{
    ### TODO
    ### check to see that $thisFile exists
    ### 
# TODO block
# Find meetings that have a topic that starts with this pattern [A][0-9]+\.
# Parse date/time into something friendly
    while IFS='' read -r thisHost ; do
	msg "Getting meetings for host $thisHost"
	curl -s --location --request GET 'https://api.zoom.us/v2/users/'$thisHost'/meetings?type=upcoming&page_size=50' \
	     --header 'Authorization: Bearer '$thisAuth\
	     --header 'Cookie: _zm_lang=en-US; cred=FDF6F1139CCFA57C3B0B63CA0FC0EC43' -o $tmp/$thisHost.meetings.json
	jq --raw-output '.meetings[].id' $tmp/$thisHost.meetings.json > $tmp/$thisHost.meetings.list
	while IFS='' read -r thisMeeting ; do
	    msg "Getting meeting details for $thisMeeting"
	    getMeetingDetails $thisMeeting
	done < $tmp/$thisHost.meetings.list
    done < $thisFile
#    jq --raw-output '.meetings[]| [.topic, .join_url,.id] | @tsv' meetings.json |  sort --version-sort > just.links.tsv
#    jq --raw-output '.topic, .agenda, .join_url,"Password: " +.password,"Phone number: " + .settings.global_dial_in_numbers[1] .number' $thisMeeting.json > $thisMeeting.txt
#    jq -r '.occurrences[].start_time' $thisMeeting.json | xargs -I DATE date -d "DATE" +"<td>%B %d %-I:%M %p</td>" >> $thisMeeting.txt
#jq -s . *.meetings.json > all.json
#jq '.[].meetings[] | [.topic, .join_url, .start_time] | @tsv' all.json > all.meetings.tsv
### TODO
### Link Host Id to real name
}
getMeetingDetails()
{
    currentMeeting=$1
    msg "Getting $currentMeeting details"

    curl -s --location --request GET 'https://api.zoom.us/v2/meetings/'$currentMeeting'?occurrence_id=%3Cstring%3E' \
     --header 'Authorization: Bearer '$thisAuth\
     --header 'Cookie: _zm_lang=en-US; cred=DF1D1094C925352ECFFAE5C05E468CA4' -o $tmp/$currentMeeting-details.json
}

reportMeetingDetails()
{
    msg "Preparing report"
    jq --slurp '.' $tmp/*-details.json > big.json
    echo "<h2>WISE Events Zoom Links</h2>" >> zoom.events.html
    thisDate=$(date)
    echo "<p>Updated: $thisDate" >> zoom.events.html
    jq -r -f $tools/make.event.page.jq big.json > zoom.events.tsv
    gawk -F '\t' -f /home/kh/Dropbox/tools/zoom.events.awk zoom.events.tsv  >> zoom.events.html    
}

while getopts "f:u:hv" opt; do
    case ${opt} in
	f )
	    ### host list
	    thisFile=$OPTARG
	    ;;
	u ) # Get meetings for this user
	    ### TODO
	    ### email address
	    ### Default is to get all hosts
	    thisUser=$OPTARG
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
setup
getMeetings
reportMeetingDetails
