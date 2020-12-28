#!/bin/bash
#
### make.course.list.sh - gets a list of courses, helps with catalog
###
### Uses the course information that's stored in /tmp/wa.
### You might need to use get.events.sh -t [taglist] -u to populate the directory with the stuff you need.
###
### Usage:
###   make.course.list.sh [options]
###
msg()
{
    if [  "$verbose" = true ];
    then
	thisString=$@
	echo "%% $thisString"
    fi
}


help()
{
    thisScript=$(which "$0")
    sed -rn 's/^\s*### ?//;T;p' "$thisScript"
    exit
}
tags=""
thisTitle=""
flushDir=""
tmp=~/tmp/wa
#thisDir=$(dirname "$0")
thisDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

msg "This is the tools dir: $thisDir"

mungFiles ()
{
    msg "Got thisTitle=$thisTitle"
    :>course.list.html
    echo "<head>" > course.list.html
    echo "<title>This Course List</title>" >> course.list.html
    echo "</style></head>" >> course.list.html
#
    jq --raw-output -f $thisDir/course.list.to.tsv.jq $tmp/events.json | sort --version-sort > course.list.tsv
    gawk -F'\t' -f ~/WISE-Tools/make.course.list.awk course.list.tsv >> course.list.html
}
### Options:
while getopts "uvd:t:h" opt; do
	      
    case ${opt} in
	t )
	    ### Tags
	    tagList=$OPTARG
	    ;;
	d ) # header
	    ### -d Document header 
	    thisTitle=$OPTARG
	    ;;
	v )
	    ### -v Verbose mode - TODO
	    verbose=true
	    msg "Verbose is on."
	    ;;
	h ) 
	    ### -h Prints this message
	    help
	    ;;
	?)
	help
	;;
    esac
done
mungFiles 
