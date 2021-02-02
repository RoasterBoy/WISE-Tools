BEGIN{}
{
#    printf "<br/>%s", $2
#    system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d " substr($1,0,4)  substr($1,5,2)  substr($1,7,2)  substr($1,10,2)  substr($1,12,2))
#    printf "%s\t-\t", $1
#    printf "<br/>%s", $3
}

{
    if ( $1 > NOW)
    {
    printf "<p><b>%s</b><p>\n", $2;
    system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d @"$1"")
    printf "<br/>%s<hr/>\n", $3
    }
}

END{}
