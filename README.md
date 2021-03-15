# WISE Tools
Scripts that use the Wild Apricot API to retrieve information about events and contacts
# What is here?
This is a brief description of the tools. More detail to come.
## zm
This is the workhorse for management of WISE Zoom meetings. Use ```zm -h``` to see command options.
Requires ```jq```, ```ssconvert```, and other tools specified in ```tool.list```
## savethedate
This command fetches the WISE calendar .ics file and mungs it into an HTML file that can be used for the WISE bulletin.
Requireds ```ical2json```