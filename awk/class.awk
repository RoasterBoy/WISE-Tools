BEGIN {
    NR==1; {print "<h1>Report</h1>" }
}
{
    printf "<h2>%s</h2>\n", $4
    printf "<br>\n"
    # the following suppresses the 0 that's returned by the system() command
    system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d "$3); print ""
    printf "<br>%s\n", $5
}
END{
}
    
