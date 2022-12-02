#!/bin/bash
#
tmp=~/tmp/wa
    mkdir -p "$tmp"
    touch "$tmp"/tmp.tmp
    rm -r "${tmp:?}"/*
thisAuth=$(get.auth.sh)
echo "We are checking to see if upcoming WISE courses have registration enabled."
echo "We don't want early registrations."
waevents -u
#jq --compact-output --raw-output '.Events[] |[ .HasEnabledRegistrationTypes, .Name] | @sh' ~/tmp/wa/events.json > course.status.txt
while IFS='' read -r thisEvent; do
    curl -s --header "Authorization: Bearer $thisAuth"\
	 'https://api.wildapricot.org/v2.2/accounts/'"$WA_account"'/events/'$thisEvent -o $tmp/$thisEvent.json
    jq '.Details | .RegistrationTypes[] | [.AvailableForMembershipLevels[].Id] | @csv' $tmp/$thisEvent.json > $thisEvent.csv
done < $tmp/events.list


