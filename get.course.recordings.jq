select(.total_records > 0) | .meetings[] | select(.topic|test("^[AB][0-9]+")) | [(.start_time|fromdate), .topic, (.recording_files[] | select(.file_type == "MP4") | .play_url)] | @tsv
