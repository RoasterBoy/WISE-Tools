. | select(.code == null) | .participants[] | [.user_name, .join_time, .location,.network_type, .microphone, .speaker, .camera, .version,.ip_address] | @csv 