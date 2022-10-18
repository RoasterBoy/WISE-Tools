# WISE Tools
Scripts that use the Wild Apricot API to retrieve information about events and contacts
# What is here?
This is a brief description of the tools. More detail to come.
## zm
This is the workhorse for management of WISE Zoom meetings. Use ```zm -h``` to see command options.
Requires ```jq```, ```ssconvert```, and other tools specified in ```tool.list```
## How it works
```zm``` uses the Zoom API to pull meeting and recording URLs.
### Credentials
The script requires the Zoom API key and Secret, which comes from the
Zoom developer account. The authorization is then built with
JWT. Note: Zoom had indicated that JWT is going away by June 2023, to
be resplaced by a yet-to-be-determined new authorization method.
### Recordings
Recordings are temporary stored in offline. 
# Other Tools
There are some other scripts here.
## savethedate
This command fetches the WISE calendar .ics file and mungs it into an HTML file that can be used for the WISE bulletin.
Requireds ```ical2json```
## evals
Mungs .zip files from Google Forms into a format that can be used by
our instructator evaluation coordinator. The zip files contain the
responses in .csv format.
Update: Google Forms now provides PDF output in a usable form, so this script is no longer required. 
## wafiles
This script uses ```curl``` to push a file, typically an HTML file containing Zoom links, to the Wild Apricot file system.
