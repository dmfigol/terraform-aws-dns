# Validation test - both records and alias specified
test_dns_records = {
  "invalid-record" = {
    type    = "A"
    zone    = "example.com"
    records = ["1.1.1.1"]
    alias = {
      name = "target.example.com"
    }
  }
}