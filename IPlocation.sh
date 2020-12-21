#!/bin/bash
#

:> this.json
for file in ~/tmp/zoom/*participants.json;
do
#x    jq -rf ~/WISE-Tools/mumble.jq $file > this.json
    #    jq '[.participants[] | {user: .user_name, address: .ip_address, device: .device}]' $file > this.json
    echo "[" $file.IP.json
    jq -r '.participants[]|.ip_address' $file  | xargs -I thisIP curl -s 'https://freegeoip.app/json/'thisIP >>  $file.IP.json
    echo "]" $file.IP.json


	#jq -r '[.query, .city + " " + .region_code] | @csv' | sort -k1,1 -u >> this.csv
    #   sleep 1.5
    
done
#http://ipwhois.app/json

# Let's loop through the IP addresses in a file, then all files
#jq -r '.participants[].ip_address'  96576345460.participants.json

