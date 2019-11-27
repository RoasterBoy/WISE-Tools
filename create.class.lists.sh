$!/bin/bash
#
# Get events
# for each course
# Extract Course title, date/time, location and put into header file.
echo $1
jq 'def thisLength: .Sessions | length;  def repeat(f; n):  def r:  if .[0] >= n then empty else (.[1] | f), (.[0] += 1 | r) end;   [0, .] | r; .Name,.Location,"|"+ ( [.Sessions[] | .StartDate | strptime("%Y-%m-%dT%H:%M:%S%Z") | strftime("%m/%d | ")] | @csv), repeat("---"; thisLength)' $1 > moo.csv
# store # of sessions and pass it to function that creates the list.
# Get details for each course
# Remove or flag waitlisted people
# Prettify it by sending it through pandoc
#
