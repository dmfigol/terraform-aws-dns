output "records" {
  description = "Map of all created DNS records"
  value = {
    for key, record in aws_route53_record.this : key => {
      id      = record.id
      name    = record.name
      type    = record.type
      zone_id = record.zone_id
      fqdn    = record.fqdn
      records = record.records
      ttl     = record.ttl
    }
  }
}