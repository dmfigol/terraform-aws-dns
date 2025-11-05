# Create DNS records using a single resource with dynamic alias blocks
resource "aws_route53_record" "this" {
  for_each = {
    for key, record in var.dns_records :
    key => record
    if contains(keys(local.zone_map), record.zone) &&
    (record.zone_type == null ||
      (record.zone_type == "public" && !local.zone_map[record.zone].private_zone) ||
    (record.zone_type == "private" && local.zone_map[record.zone].private_zone))
  }

  zone_id = local.zone_map[each.value.zone].zone_id
  name    = coalesce(each.value.name, each.key)
  type    = each.value.type
  ttl     = each.value.alias != null ? null : each.value.ttl
  records = each.value.alias != null ? null : each.value.records

  dynamic "alias" {
    for_each = each.value.alias != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = coalesce(alias.value.zone_id, local.zone_map[each.value.zone].zone_id)
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}