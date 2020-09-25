select(.id != null) | [.topic, .join_url,  (.agenda | sub("\\n"; "; ")),(.settings.global_dial_in_numbers[].number | sub("\\+1 ";"")),(.id | tostring) ,.password, .settings.alternative_hosts] | @tsv

