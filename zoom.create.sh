#!/bin/bash
# Creates a Zoom meeting, typically used for courses
#
### Creates a Zoom meeting
### Required parameters
### 1 - Topic. Must be a quoted string
### 2 - Start date-time. Must be a valid date-time string "YYY-MM-DD HH:MMp"
### 3 - Number of class meetings, default is 5
### use -f <file> to store values in a CSV file
set -e
start_time="$(date -u +%s)"
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
setup()
{
    thisDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    thisAuth=$(python $thisDir/get.auth.py)
    msg "Initializing ..."
    # Returned data
    thisMtg=$tmp/thisCourse.json
}
init()

{
    tmp=~/tmp/zoom
    mkdir -p "$tmp"
    touch "$tmp"/tmp.tmp
    rm -r "${tmp:?}"/*
}
#
createCourse()
{
    topic=$1
    startTime=$2
    repeats=$3
    if [[ -z $repeats ]]; then
	repeats=5
    fi
    echo $startTime
    password=$(date '+%s')
    thisStart=$(date --date=$startTime +"%Y-%m-%dT%H:%M:00")
    dow=$(date --date $startTime +%u)
    thisOut=$(echo $topic | sed -e 's/.\([CD][0-9]*\).*/\1.json/')
    echo $thisOut
    exit
cat <<Endofmessage >payload.json
{
    "host_id": "sZbpHXjlQxiQHTLao_-paA",
    "topic": $topic,
    "agenda": "Host: TBD<br/>Class Assistant: TBD",
    "password": "password",
    "type": 8,
    "status": "waiting",
    "duration":90,
    "start_time": $thisStart,
    "recurrence": {
	"repeat_interval": 1,
	"type": 2,
	"weekly_days": $thisDow,
	"end_times":$repeats
    },
    "settings": {
	"join_before_host": true,
	"jbh_time": 15,
	"end_time": 5,
	"approval_type": 2,
	"auto_recording": "cloud",
	"alternative_hosts": "",
	"global_dial_in_countries": [
	    "US"
	]},
    "tracking_fields": [
	{"field": "Meeting type",
	 "value": "Course",
	 "visible": true
	}
]
}
	
Endofmessage

}

uploadCourse()
{
=======
{
    tmp=~/tmp/zoom
    mkdir -p "$tmp"
    touch "$tmp"/tmp.tmp
    rm -r "${tmp:?}"/*
}

inFile=$1
counter=0
thisAuth=$(python ~/WISE-Tools/get.auth.py)
while IFS=$'\t' read -r topic thisDate sessions; do
    echo "Got \$topic: $topic"
    echo "Got \$thisStart $thisStart"
    echo "Got \$sessions $sessions"
    counter=$((counter+1))
    payload=payload$counter.json
    courseFile=course$counter.json
    password=$(date '+%s')
    dow=$(date --date="$thisStart" +%u)
    thisDow=$((dow + 1)) 
    thisStart=$(date --date="$thisDate" +"%Y-%m-%dT%H:%M:00")

    ### Creates a Zoom meeting
    ### Required fields
    ### 1 - Topic. Must be a quoted string
    ### 2 - Start date-time. Must be a valid date-time string "YYY-MM-DD HH:MMp"
    ### 3 - Number of class meetings, typically 5
    # Make sure that we have all of the values needed
    if [[ -z $topic || -z  $thisStart || -z $sessions ]]; then
	echo 'one or more variables are undefined'
	exit 1
    fi
        cat <<-EOF > $payload
    { 
       "host_id": "sZbpHXjlQxiQHTLao_-paA",
       "topic": "$topic",
       "type": 8,
       "timezone": "America/New_York",
       "agenda": "Host: TBD<br/>Class Assistant: TBD",
       "password": "$password",
       "recurrence": {
       		     "type": 2,
       		     "weekly_days": "$thisDow",
		     "repeat_interval": 1,
		     "end_times": $sessions
		          },
     "start_time": "$thisStart",
     "duration": 90,
     "settings": {
      		     "join_before_host": true,
     		     "jbh_time": 15,
		     "approval_type": 2,
		     "auto_recording": "cloud",
		     "alternative_hosts": "",
		     "global_dial_in_countries": [
		     		 "US"
				          ]},
     "tracking_fields": [{
     			"field": "Meeting type",
			"value": "Course",
			"visible": true
			}]
    }
EOF
curl  --location --request  POST 'https://api.zoom.us/v2/users/sZbpHXjlQxiQHTLao_-paA/meetings' \
      --header 'content-type: application/json' -d "@$payload" \
      --header 'Authorization: Bearer '"$thisAuth" -o $courseFile.json
done < $inFile

# Now do it
# For now, we'll use Karl's user ID
#
# sZbpHXjlQxiQHTLao_-paA
#

curl  --location --request  POST 'https://api.zoom.us/v2/users/sZbpHXjlQxiQHTLao_-paA/meetings' \
      --header 'content-type: application/json' -d "@payload.json" \
      --header 'Authorization: Bearer '"$thisAuth" -o thisCourse.json
}
gotArgs()
{
    echo "got \$1 $1"
    echo "got \$2 $2"
    echo "got \$3 $3"
 }

while getopts "f:v" opt; do
    case ${opt} in
	f )
	    ### -f CSV file with course info
	    thisFile=$OPTARG
	    ;;
	v )
	    verbose=true
	    ;;
    esac
done
echo "thisFile is $thisFile"  
setup
init
awk -F, '{print $1, $2, $3}' $thisFile 

#python -mjson.tool payload.json

  
