BEGIN {}
{
    printf "<h2>%s</h2>\n", $1
    printf "<p><b>Zoom Link</b>: <a href='%s'>%s</a>", $2, $2
    printf "<br>%s", $3
    print "<br/>"
    # Agenda
    printf "Phone: %s", $4
    printf "<br>Meeting ID: %s", $5
    printf "<br>Password: %s", $6
    printf "<br/>%s\n", $7
    if (length($8) > 0) {
	        print "<h3>Meeting Times</h3>\n"
		for(i=8; i<=NF; i++)  printf "<br>\n", system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d "$i"") 
    }
}
END{}
    
