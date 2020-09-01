.Events[] | if ( .Tags[] | contains ("fall") ) then "<h1><a href=' "+ .Url + "'", .Name + "</a></h1>", [(.Sessions[] |.StartDate)| strptime("%Y-%m-%dT%H:%M:%S%Z") | strftime("%B %d,") ]| join(" ") | rtrimstr\
\
(",")) else empty end 
