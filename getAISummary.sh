if [ -z "$1" ]; then
    echo "Missing meeting ID.."
    exit
fi

getHosts()
{
    hostList=hosts.list
    :>$hostList
    echo "Getting hosts"
    curl -s --location --request GET 'https://api.zoom.us/v2/users?status=active&page_size=30' \
	 --header 'Authorization: Bearer '"$thisAuth" -o hosts.json
    jq -r '.users[] | select(.type == 2)  | .id' hosts.json > $hostList
    echo "Got hosts"
    exit
    }
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
thisAuth=$(curl -s --location 		--request POST 'https://zoom.us/oauth/token?grant_type=account_credentials&account_id='"$Zoom_OAuth_ACCOUNT" --header 'Authorization: Basic '$credentials | jq -r '.access_token' )
#    getHosts

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
jq -r '"\n\n" + .meeting_start_time |  strptime("%Y-%m-%dT%H:%M:%S%Z") | strftime("%B %-e,%Y") ' thisInstance.json >> $thisFile.md
jq -r '(.summary_details[]|"\n## " +.label+"\n\n",.summary),"\n\n## Next Steps","1. "+.next_steps[]' thisInstance.json >> $thisFile.md
pandoc -f gfm --toc -s --metadata title="$thisTitle" -o new.md $thisFile.md
pandoc --include-in-header=header.md --pdf-engine=weasyprint new.md -o $thisFile.pdf
