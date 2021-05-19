#!/bin/bash
# This script creates a cadaver.put file, allowing us to put a file on our Wild Apricot server.
#
# $1 is the file or files. Must quote filespecs that have wildcards.
# $2 is the location, relative to /resources. We don't, at this time, have a way to confirm that the
# location exists or is writeable. Use with caution; this could end badly.
#
# login information is in .netrc
#
createPutFile()
{
    [[ -z "$thisDir" ]] && { echo "No target directory. Exiting..." ; exit 1; }
    thisPutFile=cadaver.put
    echo "open https://assumptioncollegewise.wildapricot.org/resources" > $thisPutFile
    printf "%s\n" "cd $thisDir" >> $thisPutFile
    for f in $thisFile; do
	thisFile=$(basename $f)
	printf "%s\n" "put $f $thisFile"  >> $thisPutFile
        done
    printf "%s\n" "exit" >> $thisPutFile
}

doit()
{
    cadaver --rcfile=cadaver.put
    printf '%d\n' $?
#    echo "We would do this here"
}
getHelp()
{
    echo "-b  Blog and Bulletin indexes go to Documents/reference/"
    echo "-l  Files containing Zoom links go to Links" 
    echo "-w  Others go to Documents/website"
    echo "-c  Put files in Documents/class.assistants"
}
while getopts "b:l:w:c:h" opt; do
    case ${opt} in
	b) # Blogs
	    thisFile=$OPTARG
	    thisDir="Documents/reference"
	    ;;
	c) # Class Assistants
	    thisFile=$OPTARG
	    thisDir="Documents/class.assistants"
	    ;;
	l) # Links
	    thisFile=$OPTARG
	    thisDir="Links"
	    ;;
	w) # Other stuff
	    thisFile=$OPTARG
	    thisDir="Documents/website"
	    ;;
	h) # Print help and exit
	    getHelp
	    ;;
	?)
	getHelp
	;;

    esac
    done

createPutFile
doit
