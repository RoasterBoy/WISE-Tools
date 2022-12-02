BEGIN{}
{
    if ( $1 > NOW)
    {
    printf "<p><b>%s</b><p>\n", $2;
    system("date +%B%_3d,%_5Y\" \"%-I:%M%_3p -d @"$1"")
    printf "<br/>%s<hr/>\n", $3
    # Getting this month
    "date +%-m -d @"$1"" | getline thisMonth;
    if (thisMonth + 0 == startMonth + 1)
	# if we're into a new month, print Read More code
    {
	startMonth=0
	print "*|IFNOT:ARCHIVE_PAGE|*&lt;a href=&quot;*|ARCHIVE|*#Events &quot; target=&quot;_blank&quot;&gt;See more upcoming events&lt;/a&gt;*|END:IF|* *|IF:ARCHIVE_PAGE|*" }
    }
    
}

END{}
