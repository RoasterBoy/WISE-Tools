"https://assumptionwise.org/event-" as $orgUrl |.Events[] | [.Name, $orgUrl + (.Id|tostring), "Starts: " + ( .StartDate | strptime("%Y-%m-%dT%H:%M:%S%Z") | strftime("%B %-e %-I:%M %p"))] | @tsv
