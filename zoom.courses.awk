BEGIN {}
{
    printf "<h2>%s</h2>\n", $1
    printf "<p><b>Zoom Link</b>: <a href='%s'>%s</a>", $2, $2
    #host and class assistant
    printf "<br>%s", $3
    printf "<br>Phone: %s", $4
    printf "<br>Meeting ID: %s", $5
    printf "<br>Password: %s", $6
    printf "<br/>%s" , $7
    {for(i=8; i<=NF; i++) printf "<br>%s\n", $i}
}
END{}
    
