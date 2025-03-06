    accountId="$Zoom_OAuth_ACCOUNT"
    clientId="$Zoom_OAuth_CLIENT"
    clientSecret="$Zoom_OAuth_SECRET"

    credentials=$(echo -n $Zoom_OAuth_CLIENT:$Zoom_OAuth_SECRET | base64)
    thisAuth=$(curl -s --location 		--request POST 'https://zoom.us/oauth/token?grant_type=account_credentials&account_id='$accountId --header 'Authorization: Basic '$credentials | jq -r '.access_token')
    curl --request GET \
  --url 'https://api.zoom.us/v2/meetings/O9oGqfc0RGS6TsoD0pO%2FCQ%3D%3D/meeting_summary' \
  --header 'Authorization: Bearer '"$thisAuth" -o meeting.json
    thisFile=$(jq -r '.meeting_id' meeting.json)
    thisTitle=$(jq -r '.summary_title' meeting.json)
    jq -r '"\n\n" + .meeting_start_time |  strptime("%Y-%m-%dT%H:%M:%S%Z") | strftime("%B %-e,%Y") ' meeting.json > $thisFile.md
    jq -r '(.summary_details[]|"\n## " +.label+"\n\n",.summary),"\n\n## Next Steps","1. "+.next_steps[]' meeting.json >> $thisFile.md
    pandoc -f gfm --toc -s --metadata title="$thisTitle" -o new.md $thisFile.md
    pandoc new.md -o $thisFile.docx
