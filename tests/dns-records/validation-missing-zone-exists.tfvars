test_dns_records = {
  record1 = {
    name    = "test1"
    type    = "A"
    records = ["1.2.3.4"]
    zone    = "nonexistent-zone.com" # This zone doesn't exist
  }
  record2 = {
    name    = "test2"
    type    = "A"
    records = ["5.6.7.8"]
    zone    = "also-missing-zone.com" # This zone also doesn't exist
  }
}