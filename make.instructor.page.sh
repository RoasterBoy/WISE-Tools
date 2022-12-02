#!/bin/bash
#
tmp=~/tmp/wa
mkdir -p $tmp 
setup()
{
    thisDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    thisAuth=$(get.auth.sh)
    justLinks=$tmp/just.links.tsv
    msg "Initializing $justLinks"
    :>"$justLinks"
    sortedLinks=$tmp/sorted.links.tsv
    msg "Doing setup for \$rptType $rptType "
    HTMLFile=$tmp/$rptType.html
    msg "Initializing $HTMLFile"
    :>"$HTMLFile"
    if [[ $simple = "false" ]]; then
	echo "<h2>$rptTitle</h2>" > "$HTMLFile"
	thisDate=$(date  +"%B %d, %Y %-I:%m %p")
	echo "<p>Updated: $thisDate" >> "$HTMLFile"
    fi
}
setup 

rptTtile="WISE Course Materials"
curl -s --header "Authorization: Bearer $thisAuth"\
     'https://api.wildapricot.org/v2.2/accounts/'"$WA_account"'/Events'"$filterString" -o $tmp/events.json
jq '.[] | sort_by(.Id) | .[].Id | rtrimstr(",")' $tmp/events.json > $tmp/events.list
jq --slurp -f $thisDir/instructor.page.jq $tmp/events.json > $tmp/events.tsv
