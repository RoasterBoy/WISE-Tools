#!/bin/bash
#
### get.zoom.hosts.sh - get list of Zoom pro license holders
###
### Usage:
###   get.zoom.hosts.sh [options]
###
### Options:
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
	# echo "Verbose is $verbose"
	thisString=$@
	echo "%% $thisString"
    fi
}
setup()
{
    tmp=~/tmp/zoom
    mkdir -p $tmp
    thisList=$tmp/hosts.list
    thisJSON=$tmp/hosts.json
    msg "Host list is $thisList"
    msg "JSON file is $thisJSON"
}
thisAuth=$(python3 $tools/get.auth.py)
getHosts()
{
    #    | jq -r '.users[].email' > this.list.txt
    # User types
    # 1 - Basic
    # 2 - Licensed
    # 
    curl -s --location --request GET 'https://api.zoom.us/v2/users?status=active&page_size=30' \
	 --header 'Authorization: Bearer '$thisAuth \
	 --header 'Cookie: _zm_lang=en-US; cred=E847D55F4DDCDBC0D8EE197899BCB2C9' -o $thisJSON
    jq -r '.users[] | select(.type == 2)  | .id' $thisJSON > $thisList
}
while getopts "u:hv" opt; do
    case ${opt} in
	u ) # Get this user
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
getHosts
echo $thisList
