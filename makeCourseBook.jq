def myDate(d): d | split(":") | .[0] + ":" + .[1] + ":" + .[2] + .[3] | strptime("%Y-%m-%dT%H:%M:%S%z") | strftime("%B %Y");
. | "<br/><a href=\"https://assumptionwise.org/event-" + (.Id|tostring) + "\">" + .Name + "</a> <i>" +   myDate(.StartDate) + "</i>" + .Details.DescriptionHtml, (.Tags | sort | .[])
