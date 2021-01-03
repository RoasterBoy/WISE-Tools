BEGIN {}
{
    printf "<h2>%s</h2>\n", $2
    printf "<p>%s", $4
    printf "Date/Time:%s\n", $1
    printf "<p/>Zoom Link: <a href='%s'>%s</a></p>\n<hr/>", $3, $3
}
END{} 

    
