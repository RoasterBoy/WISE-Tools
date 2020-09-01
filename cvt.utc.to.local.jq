{"@timestamp": "2020-05-04T18:02:13Z"}
| .["@timestamp"]
| fromdateiso8601   # converts to seconds
| gmtime
| strftime("%Y-%m-%dT%H:%M:%S%Z")