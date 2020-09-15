. | select(.code == null) | [(.start_time | fromdate), .topic,( .recording_files[] | select(.file_type == "MP4") | .play_url), (.start_time | fromdate | strftime("%B %-d, %Y"))] | @tsv
