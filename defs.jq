def fmtDate(t): t| fromdate | strftime("%B %-d, %Y") ;
def fmtTime(z): z | fromdate | strftime("%B %-e %-I:%M %p"); fmtTime(.start_time)
