def myDateTime(d): d | split(":") | .[0] + ":" + .[1] + ":" + .[2] + .[3] |
strptime("%Y-%m-%dT%H:%M:%S%z") | strftime("%A, %b %-d, %Y %-I:%M %p");
