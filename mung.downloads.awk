BEGIN {}
{
    printf "%s", match($0, /[A-D][0-9]+/) { print substr($0, RSTART, RLENGTH)}
    printf "%s\n", strftime("Date: %Y.%m.%d.%H.%M", $1)
}

END
