BEGIN {}
{
    printf "<h2>%s</h2>\n", $1
    print strftime("<p>Date: %B %-d %-I:%M %p", $2)
    printf "<br/>Zoom Link: <a href='%s'>%s</a></p>\n<hr/>", $3, $3
}
END{}     # End section

    
