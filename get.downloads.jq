.[] | .meetings[] | select(.id == $ID) | select(.topic|test("^[A-D][0-9]+")) | (.topic| capture("(?<ID>[A-D][0-9])") | .ID)  +"-"+( (.recording_files[] | select(.file_type=="MP4") | .recording_start | fromdate | tostring)) + ".mp4"