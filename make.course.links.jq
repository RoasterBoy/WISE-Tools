select(.id != null) | [.topic, .join_url, (.agenda | sub( "\n"; "<br/>";"g")) ,if ( .settings.global_dial_in_numbers != null) then .settings.global_dial_in_numbers[].number else "No dial-in phone" end,"Meeting ID: "+(.id | tostring) ,.password, "Alternate hosts: " + (.settings.alternative_hosts  | gsub(";";"<br/>"))] | @tsv