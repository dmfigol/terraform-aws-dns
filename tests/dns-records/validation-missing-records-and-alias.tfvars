# Validation test - missing both records and alias
test_dns_records = {
  "invalid-record" = {
    type = "A"
    zone = "example.com"
    # Missing both records and alias
  }
}