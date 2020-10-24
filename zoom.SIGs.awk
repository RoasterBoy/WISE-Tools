BEGIN {}
{
    printf "<h2>%s</h2>\n", $1
    printf "<p><b>Zoom Link</b>: <a href='%s'>%s</a>", $2, $2
    print "<p><b>Meeting time(s)</b>"
    printf "<br/>%s\n" , $7
    print "<hr/>"
    # Agenda
    if (length($3) > 0) printf "<p>%s<p>", $3
    printf "Phone: %s", $4
    printf "<br>Meeting ID: %s", $5
    printf "<br>Password: %s", $6

    
}
END{}
    
