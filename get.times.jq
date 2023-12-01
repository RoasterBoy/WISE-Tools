if (.occurrences != null)  then ([(.occurrences[] | select(.status != "deleted") )] |.[0].start_time |fromdate) else (.start_time|fromdate) end
