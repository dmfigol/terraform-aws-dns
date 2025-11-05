# Validation test - missing zone
test_dns_records = {
  "invalid-record" = {
    type = "A"
    # Missing zone
    records = ["1.1.1.1"]
  }
}