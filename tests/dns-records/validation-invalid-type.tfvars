# Validation test - invalid record type
test_dns_records = {
  "invalid-record" = {
    type    = "INVALID"
    zone    = "example.com"
    records = ["1.1.1.1"]
  }
}