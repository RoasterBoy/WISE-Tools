BEGIN {}
{
    printf "<h2>%s</h2>\n", $1
    printf "<p><b>Zoom Link</b>: <a href='%s'>%s</a>", $2, $2
    printf "<br>%s", $3
#    print "<p><b>Meeting time(s)</b>"
#    printf "<br/>%s\n" , $7
    print "<br/>"
    # Agenda
    printf "Phone: %s", $4
    printf "<br>Meeting ID: %s", $5
    printf "<br>Password: %s", $6
    printf "<br/>%s\n", $7
    if (length($8) > 0) {
	        printf "<h3>Meeting Times</h3>\n"
		for(i=8; i<=NF; i++) printf "%s<br/>\n", (strftime("%B %d, %Y %-I:%M %p", $i))
    }
}
END{}
	# 
    
