BEGIN {}
{
    printf "<h2>%s</h2>\n", $2
    system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d "$1)
    # Agenda
    printf "<p>%s\n", $4
    printf "<p><b>Zoom Link</b>: <a href='%s'>%s</a>", $3, $3
    printf "<p>Phone: %s", $5
    printf "<br>Meeting ID: %s", $6
    printf "<br>Password: %s\n", $7

#    if (length($8) > 0) {
#	        print "<h3>Meeting Times</h3><p>\n"
#		for(i=8; i<=NF; i++)  printf "<br>\n", system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d "$i"") 
 #   }
}
END{}
    
