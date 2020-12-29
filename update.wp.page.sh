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
cat   $postFile  | wp --debug --path=/home/karlh9n/wiselearners.org  post update $postNumber -
