BEGIN {}
{
    printf "<h2>%s</h2>\n", $2
    printf "<p>Date/Time: "
    system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d "$1)
    printf "<p/>Zoom Link: <a href='%s'>%s</a></p>\n<hr/>", $3, $3
}
END{} 

    
