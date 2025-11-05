test_dns_records = {
  record1 = {
    name      = "test1"
    type      = "A"
    records   = ["1.2.3.4"]
    zone      = "aws.dmfigol.me" # This exists as both private and public
    zone_type = "public"         # Explicitly specifying zone_type should prevent warning
  }
  record2 = {
    name      = "test2"
    type      = "AAAA"
    records   = ["2001:4860:4860::8888"]
    zone      = "aws.dmfigol.me" # Same ambiguous zone
    zone_type = "private"        # Explicitly specifying zone_type should prevent warning
  }
}