locals {
  # Group zones by name to handle duplicates (same name, different types/IDs)
  zones_by_name = {
    for zone_name in toset([
      for zone_id, zone_data in data.aws_route53_zone.all : zone_data.name
    ]) :
    zone_name => [
      for zone_id, zone_data in data.aws_route53_zone.all :
      zone_data if zone_data.name == zone_name
    ]
  }

  # Create a map of zone names to zone data for easy lookup
  # For duplicate zone names, prefer public zones over private ones
  zone_map = {
    for zone_name, zone_list in local.zones_by_name :
    zone_name => (
      length([for zone in zone_list : zone if !zone.private_zone]) > 0 ?
      [for zone in zone_list : zone if !zone.private_zone][0] :
      zone_list[0]
    )
  }

  # Get all unique zone names from DNS records
  required_zones = toset([
    for key, record in var.dns_records : record.zone
  ])

  # List of available zone names in the account
  available_zone_names = tolist(keys(local.zone_map))

  # Find zones that are referenced but don't exist
  missing_zones = toset([
    for zone in local.required_zones :
    zone if !contains(local.available_zone_names, zone)
  ])

  # Find zones that have both private and public versions (ambiguous)
  # Only consider zones ambiguous if the user hasn't specified zone_type to resolve the ambiguity
  ambiguous_zones = toset([
    for zone_name, zone_list in local.zones_by_name :
    zone_name if length(zone_list) > 1 && length([
      for key, record in var.dns_records :
      record.zone if record.zone == zone_name && record.zone_type == null
    ]) > 0
  ])
}