if (.occurrences != null)  then [(.occurrences[0].start_time) | fromdate] else [.start_time | (fromdate)] end | @tsv
