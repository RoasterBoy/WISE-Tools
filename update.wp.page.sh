#!/bin/bash
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
# Next step is to run it from my local system via ssh
#
# post number is $1
# file is $2
# title is $3
postNumber=$1
postFile=$2
#wp --ssh karlh9n@mactarnahans.dreamhost.com update 944 --post_title="New Stuff" --debug course.list.html
wp post update $postNumber  $postFile --ssh karlh9n@mactarnahans.dreamhost.com:~/wiselearners.org
