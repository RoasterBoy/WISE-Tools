BEGIN {}
{
    # Skipping $1, which is the Unix time string that we use for sorting these items
    printf "<h2>%s</h2>\n", $2
    printf "<p>Date: %s", $4
    printf "<br/> <a href='%s'>Recording Link</a></p>\n<hr/>", $3
}
END{}     # End section

    
