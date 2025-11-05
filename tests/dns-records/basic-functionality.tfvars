# Basic functionality test - valid A and CNAME records
test_dns_records = {
  "test-a.example.com" = {
    name    = "test-a.example.com"
    type    = "A"
    zone    = "example.com"
    records = ["1.2.3.4"]
    ttl     = 300
  }
  "test-cname.example.com" = {
    name    = "test-cname.example.com"
    type    = "CNAME"
    zone    = "example.com"
    records = ["test-a.example.com"]
    ttl     = 300
  }
}