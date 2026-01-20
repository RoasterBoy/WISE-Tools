#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ -z "$1" ]; then
    echo "Missing meeting ID.."
    exit
fi

#echo "Client: $Zoom_OAuth_CLIENT"
#echo "Secret: ${Zoom_OAuth_SECRET:0:5}..."  # Only show first 5 chars for security
#echo "Account: $Zoom_OAuth_ACCOUNT"


dblEncode()
{
#    echo $1
    that=$(urlencode $1)
#    echo $that
    other=$(urlencode $that)
#   echo $other
}
thisMeeting=$(echo "$1" | tr -d [:blank:])
echo $thisMeeting
credentials=$(echo -n $Zoom_OAuth_CLIENT:$Zoom_OAuth_SECRET | base64)

curl -s --location --request POST 'https://zoom.us/oauth/token?grant_type=account_credentials&account_id='"$Zoom_OAuth_ACCOUNT" --header 'Authorization: Basic '"$credentials" > tmp.json
thisAuth=$(jq -r '.access_token' tmp.json)

curl --request GET \
     --url 'https://api.zoom.us/v2/past_meetings/'"$thisMeeting"'/instances' \
     --header 'Authorization: Bearer '"$thisAuth" -o thisMeeting.json
thisUUID=$(jq -r '.meetings| sort_by(.start_time) | reverse | .[0].uuid' thisMeeting.json)
#    dblEncode $thisUUID
    #
curl --request GET \
     --url 'https://api.zoom.us/v2/meetings/'"$thisUUID"'/meeting_summary' \
     --header 'Authorization: Bearer '"$thisAuth" -o thisInstance.json
thisFile=$(jq -r '.meeting_id' thisInstance.json)
#echo "<img src="WISE-Logo_Owl.jpg">" > $thisFile.md
thisTitle=$(jq -r '.summary_title' thisInstance.json)
echo :>$thisFile.md
jq -r '.meeting_start_time | strptime("%Y-%m-%dT%H:%M:%SZ") | strftime("\n\n%B %-e, %Y")' thisInstance.json >> $thisFile.md
#jq -r '"\n\n" + .meeting_start_time | strptime("%Y-%m-%dT%H:%M:%SZ") | strftime("%B %-e, %Y")' thisInstance.json >> $thisFile.md
jq -r '(.summary_details[]|"\n## " +.label+"\n\n",.summary),"\n\n## Next Steps","1. "+.next_steps[]' thisInstance.json >> $thisFile.md
pandoc -f gfm --toc -s --metadata title="$thisTitle" -o new.md $thisFile.md
SCRIPT_DIR=$(dirname "$0")
pandoc --include-in-header=$SCRIPT_DIR/header.md --pdf-engine=weasyprint new.md -o $thisFile.pdf --pdf-engine-opt=-q
