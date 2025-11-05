test_dns_records = {
  record1 = {
    name    = "test1"
    type    = "A"
    records = ["1.2.3.4"]
    zone    = "aws.dmfigol.me" # This exists as both private and public
  }
}