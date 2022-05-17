# rtrimstr is needed because sometimes people add a space at the end of a tracking field.
select( (.tracking_fields) != null) | select(.tracking_fields[].value | rtrimstr(" ") == $TYPE) | .id