BEGIN {
}
{
    if (FNR==1)
    {printf "<h1>Course list for %s</h1>\n", $2 }
    printf "<p><b>%s</b><p>\n", $4
    # the following suppresses the 0 that's returned by the system() command
    system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d "$3); print ""
    printf "<br>%s\n", $5
}
END{
}
    
