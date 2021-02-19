#!/bin/bash
jq --raw-output '["WISE Member "+(input_line_number|tostring) ,.city + ", " +.region_code, .latitude, .longitude] | @tsv' $1 > moo.csv
echo "<?xml version=\"1.0\"?>" > this.gpx
echo "<gpx version=\"1.1\" creator=\"RoasterBoy\">" >> this.gpx
awk -F"\t" '{printf "<wpt lat=\"%s\" lon=\"%s\">\n<name>%s</name> <desc>%s</desc>\n</wpt>\n", $3, $4, $1, $2}' moo.csv >> this.gpx
echo "</gpx>" >> this.gpx

