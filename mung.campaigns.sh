#!/bin/bash
#
thisDir="$( cd "$(dirname "$0")" ; pwd -P )"
thisDate=$(date)
verbose=false
#
# MC_key is stored in .bashrc
#
setup ()
{
#
    tmp=working
    if [ ! -d $tmp ]; then
	echo "tmp directory $tmp doesn\'t exist. Exiting ..."
	exit
    fi 
}
msg()
{
    if [  "$verbose" = true ];
    then
#	echo "Verbose is $verbose"
	thisString=$@
	echo "%%- $thisString"
    fi
}
getDetails()
{
    thisMailing=$1
    thisType=$2
    thisOut=$thisType.index.html
    msg "In "${FUNCNAME[0]}" with $thisMailing to $thisOut. Script has been running for "$SECONDS"."
    curl -s  --request GET \
	 --url 'https://us5.api.mailchimp.com/3.0/campaigns/'$thisMailing'/content' \
	 --user 'anystring:'$MC_key'' --output $tmp/$thisMailing.content.json
    curl -s  --request GET \
	 --url 'https://us5.api.mailchimp.com/3.0/campaigns/'$thisMailing'' \
	 --user 'anystring:'$MC_key'' --output $tmp/$thisMailing.json
    msg "Writing $thisMailing.json to $thisOut"
    jq --raw-output '.| "<h1><a href=\""+.archive_url+"\">"+.settings.subject_line+"</a></h1><p>"' $tmp/$thisMailing.json >> $thisOut
    jq -r '.html' working/$thisMailing.content.json | pup 'h2 text{}' |  sed -e 's/\([a-zA-Z.)>]\+\)$/\1<br>/g' >> $thisOut

    #    
    #    wkhtmltopdf $thisMailing.html $thisMailing.pdf

}
#--------------------------------------------------------- 

mungIt()
{

echo '<p><img src="/resources/Pictures/WISE-Logo-Banner@2x-100.jpg" alt="WISE Logo" title="WISE Logo" width="600" border="0"></p>' > index.html
echo "Page created on $thisDate" >> index.html
cp index.html blog.index.html
cp index.html bulletin.index.html

    while IFS='' read -r thisLine ; do
    getDetails $thisLine bulletin
done  < working/campaigns.list
while IFS='' read -r thisLine ; do
    getDetails $thisLine blog
done  < working/blogs.list
}
cleanUp()
{
msg "Doing cleanup"

    sed -ibak "/MC:SUBJECT/d" $thisOut 
#    sed -ibak2 "s/(In this issue|Contents)//g" $thisOut
    sed -ibak4 -e '/In this issue\|Contents<br>\|^WISE Bulletin.*/d' $thisOut
    sed -ibak3 '/^$/d' $thisOut
    cp $thisOut moo.tmp
    cat moo.tmp  | tr -d '\t' | iconv -c -f utf-8 -t ascii -o $thisOut 
}
#

getHelp()
{
    printf "-v verbose mode\n"
#   printf "-s Date of first campaign in series. Hint: after 2015 is good. yyyy-mm-dd"
#    printf "-n Number of campaigns. Max 100 (blogs and bulletin)"
    printf "-h Print this."
exit
}
while getopts "vs:n:h" opt; do
    case ${opt} in
	v ) # Verbose mode
	    verbose=true
	    ;;
#	s ) # Date of first campaign in series
#	    startDate=$GETOPT#
#	    ;;
#	n ) # Get this many campaigns. Manx is 100
#	    msg "Not yet implemented"
#	    exit
#	    campaignCount=$GETOPT 
#	    if [campaignCount -gt 100];
#		then 
#		msg "Campaign count exceeds 100 (MailChimp limit). Reduced to 100"
#		campaignCount=100
#	    fi 
#	    ;;
	h) # Print help and exit
	    getHelp
	    ;;
	?)
	    getHelp
	    ;;
	
    esac
done
# 
date
echo "Starting setup"
setup
echo "Munging It"
mungIt
cleanUp
date

