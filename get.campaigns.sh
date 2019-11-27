#!/bin/bash
# 
# This script uses the MailChimp API to fetch information about campaigns, lists, etc.
# 
# Uses jq
# See https://stedolan.github.io/jq/
# 
# MC_key is our API key 
# set in .bashrc
# 
# API key must be encoded to base64 with the prefix APIKEY:
# For example, APIKEY:WFVHjqxMsz9k637XCI64bEahTmO7gjv
# 
verbose=false
sinceTime=""
setup ()
{

#
tmp=working
if [ ! -d $tmp ]; then
    mkdir working
    fi 
}
getCampaigns()
{
    # MailChimp limits us to 100 campaign records, so we're starting in 2014.
    curl --request GET \
	 --url "https://us5.api.mailchimp.com/3.0/campaigns?count=200&fields=campaigns.settings.subject_line,campaigns.id,campaigns.send_time,campaigns.settings.title&sort_field=send_time$startDate" \
	 --user 'anystring:'$MC_key'' --output $tmp/campaigns.json
        jq -r '.campaigns[] | select (.settings.subject_line | contains("Bulletin")) | .id' $tmp/campaigns.json > $tmp/campaigns.list
        jq -r '.campaigns[] | select (.settings.subject_line | contains("Blog")) | .id' $tmp/campaigns.json > $tmp/blogs.list
#	 
}
#--------------------------------------------------------- 
getHelp() {
    printf "%s\n" "Usage:"
    printf "%s\n" "-v Verbose mode"
    printf "%s\n" "-s Start Date (YYYY-MM-DD)"
    printf "%s\n" "-n value - Get this many items. Max is 100."
    printf "%s\n" "-h Prints this message"
    exit
}

msg()
{
    if [  "$verbose" = true ];
    then
	thisString=$@
	echo "%%- $thisString"
    fi
}


while getopts "vs:n:h" opt; do
    case ${opt} in
	v ) # Verbose mode
	    verbose=true
	    ;;
	s ) # Date of first campaign in series
	    startDate="&since_send_time=${OPTARG}"
	    ;;
	n ) # Get this many campaigns. Max is 100
	    msg "Not yet implemented"
	    exit
	    campaignCount=${OPTARG}
	    if [campaignCount -gt 100];
		then 
		msg "Campaign count exceeds 100 \(MailChimp limit\). Reduced to 100"
		campaignCount=100
	    fi 
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
setup
getCampaigns

