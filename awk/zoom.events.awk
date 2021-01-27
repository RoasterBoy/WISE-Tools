BEGIN {}
{
    printf "<h2>%s</h2>\n", $1
    #Agenda
    printf "<p>%s\n", $3
    printf "<br>\n"
    # the following suppresses the 0 that's returned by the system() command
    system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d "$8); print ""
    printf "<p><b>Zoom Link</b>: <a href='%s'>%s</a>", $2, $2
    printf "<p>Phone: %s", $4
    printf "<br>Meeting ID: %s", $5
    printf "<br>Password: %s\n", $6
    printf "<br>%s\n", $7
}
END{}
    
