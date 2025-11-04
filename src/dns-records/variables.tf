variable "dns_records" {
  description = "DNS records configuration"
  type = map(object({
    name       = optional(string, null)
    type       = string
    records    = optional(list(string))
    ttl        = optional(number, 300)
    alias = optional(object({
      name                   = string
      zone_id                = optional(string, null)
      evaluate_target_health = optional(bool, true)
    }))
    zone = string
    zone_type = optional(string, null)  # can be private, public or null (auto-discovery)
  }))
  default = {}

  # validation {
  #   condition = alltrue(flatten([
  #     for zone_key, records in var.dns_records : [
  #       for record in records :
  #       (length(coalesce(record.records, [])) > 0 && record.alias == null) || (length(coalesce(record.records, [])) == 0 && record.alias != null)
  #     ]
  #   ]))
  #   error_message = "Each DNS record must have either 'records' or 'alias' specified, but not both."
  # }
}
