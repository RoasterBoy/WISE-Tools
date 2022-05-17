#!/bin/bash
thisDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
thisAuth=$(python3 $thisDir/get.auth.py)
tmp=~/tmp/zoom
thisID=$1
declare -i thisID=$1
curl -s --location --request GET \
                 'https://api.zoom.us/v2/meetings/'"$thisID"'/registrants' \
	         --header 'Authorization: Bearer '"$thisAuth" | \
    jq -r '.registrants[]| [.first_name, .last_name, .email, .create_time]|@csv ' > registrants.csv

