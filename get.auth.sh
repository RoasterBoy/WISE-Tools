#!/bin/bash
#
function die()
{
    local message=$1
    [ -z "$message" ] && message="Died"
    printf  "*** %s\n%s\n" "$message" "${BASH_SOURCE[1]}:${FUNCNAME[1]} line ${BASH_LINENO[0]}." 
    exit 1
}
if [ -z "$WA_key" ];
then
    die "\$WA_key not defined"
fi
# $WA_key is defined in .bashrc/.zshrc
#
thisKey=$(echo -ne "APIKEY:$WA_key"|base64)

# 
thisAuth=$(curl -s  --header "Content-Type:application/x-www-form-urlencoded" \
     --header "Authorization: Basic $thisKey" -d "grant_type=client_credentials&scope=auto"\
     https://oauth.wildapricot.org/auth/token  | jq -r '.access_token')
#
echo "$thisAuth"
