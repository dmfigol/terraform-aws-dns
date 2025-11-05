# Check if all zones listed in DNS records exist
# This will error if any zone was not found and list all missing zones
check "dns_zones_exist" {
  assert {
    condition     = length(local.missing_zones) == 0
    error_message = <<-EOT
      The following DNS zones were not found: ${join(", ", local.missing_zones)}
      
      Please ensure that:
      1. The zones exist in your AWS account
      2. You have the correct permissions to access them
      3. The zone names are spelled correctly
      
      Available zones in this account: ${join(", ", local.available_zone_names)}
    EOT
  }
}

# Check for ambiguous zones (both private and public with same domain)
# This helps users understand when zone auto-discovery might pick the wrong zone
check "dns_zones_not_ambiguous" {
  assert {
    condition     = length(local.ambiguous_zones) == 0
    error_message = <<-EOT
      Found ambiguous DNS zones (both private and public zones exist with the same domain): ${join(", ", local.ambiguous_zones)}
      
      To fix this issue, you have several options:
      1. Specify the zone_type explicitly in your DNS record configuration (set to "private" or "public")
      2. Use the zone ID instead of the zone name to uniquely identify the zone
      3. Remove one of the duplicate zones if it's not needed
      
      Example fix:
      dns_records = {
        my_record = {
          name = "example"
          type = "A"
          records = ["1.2.3.4"]
          zone = "example.com"
          zone_type = "private"  # Explicitly specify which zone to use
        }
      }
    EOT
  }
}
