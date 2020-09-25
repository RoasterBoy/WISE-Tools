.meetings[] | select(.topic|test("^[AB][0-9]+")) | .id


