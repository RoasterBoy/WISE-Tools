BEGIN{}
{
    printf "<h2><a href='%s'>%s</a></h2>", $2, $1
    {for(i=3; i<=NF; i++) printf "<br>%s\n", $i}
    
}
END{}
