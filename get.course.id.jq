. | select( (.tracking_fields) != null) | select(.tracking_fields[].value == $TYPE) | .id
. | select( (.tracking_fields) != null) | select(.tracking_fields[].value == "Course") | .id