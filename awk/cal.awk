BEGIN{}

{
    if ( $1 > NOW)
    {
    printf "<p><b>%s</b><p>\n", $2;
    system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d @"$1"")
    printf "<br/>%s<hr/>\n", $3
    }
}

END{}
