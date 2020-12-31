#!/bin/bash
msg()
{
    if [  "$verbose" = true ];
    then
	msgString=$*
	echo "%% $msgString"
    fi
}
die() {
    verbose=true
    local msg=$1
    local code=${2-1} # default exit status 1
    msg "Error: $msg %%"
    exit "$code"
}

# This is still a work in progress.
#
# Use wp-cli to replace the content of a page
#
# wp post <post-number> --post_title="<new-title>" <file-with-new-stuff>
#
# Works on remote server
#
# mactarnahans.dreamhost.com
#
# 12/29 1PM
# with ~/.wp-cli/config.yml in place
# I can use
# wp  --path=/home/karlh9n/wiselearners.org
# to execute remote commands 
#
# In order to get the content over there, it needs to be piped in. (There may be a way to do this better,
# but this works.
# 
# post number is $1
# file is $2
# title is $3
postNumber=$1
postFile=$2
#wp --ssh karlh9n@mactarnahans.dreamhost.com update 944 --post_title="New Stuff" --debug course.list.html

updatePost()
{
    postNumber=$1
    postFile=$2
    if [ ! -f "$postFile" ]; then
	die "Missing content file $postFile"
    fi
#    cat   $postFile  | wp --debug --path=/home/karlh9n/wiselearners.org  post update $postNumber -
}
getPosts()
{
    msg "Getting posts"
    wp  --path=/home/karlh9n/wiselearners.org --stdout export > everything.xml
    }

help()
{
    echo "No help yet"
}
while getopts "gu:hv" opt; do
    shopt -s nocasematch
    case ${opt} in
	    u )
	    updatePost $1 $2
	    ;;
	g )
	    getPosts
	    ;;
	h )
	    help
	    ;;
	v )
	    verbose="true"
	    ;;
	\?)
	    help
	    ;;
        * )
	    help
	    ;;
    esac
done

