. | select(.code == null) | [.topic,( .recording_files[] | select(.file_type == "MP4") | .play_url), (.start_time | fromdate | strftime("%B %-d, %Y"))] | @tsv
