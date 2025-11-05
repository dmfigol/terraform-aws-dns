# Validation test - invalid zone type
test_dns_records = {
  "invalid-record" = {
    type      = "A"
    zone      = "example.com"
    zone_type = "invalid"
    records   = ["1.1.1.1"]
  }
}