select( (.tracking_fields) != null) | select(.tracking_fields[].value == $TYPE) | .topic