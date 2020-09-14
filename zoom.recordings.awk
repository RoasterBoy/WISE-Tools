BEGIN {}
{
    printf "<h2>%s</h2>\n", $1
    printf "<p>Date: %s", $3
    printf "<br/> <a href='%s'>Recording Link</a></p>\n<hr/>", $2
}
END{}     # End section

    
