variable "dns_records" {
  description = "DNS records configuration"
  type = map(object({
    name    = optional(string, null)
    type    = string
    records = optional(list(string))
    ttl     = optional(number, 300)
    alias = optional(object({
      name                   = string
      zone_id                = optional(string, null)
      evaluate_target_health = optional(bool, true)
    }))
    zone      = string
    zone_type = optional(string, null) # can be private, public or null (auto-discovery)
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, record in var.dns_records :
      (length(coalesce(record.records, [])) > 0 && record.alias == null) ||
      (length(coalesce(record.records, [])) == 0 && record.alias != null)
    ])
    error_message = "Each DNS record must have either 'records' or 'alias' specified, but not both."
  }

  validation {
    condition = alltrue([
      for key, record in var.dns_records :
      contains(["A", "AAAA", "CNAME", "MX", "TXT", "PTR", "SRV", "SOA", "NS"], record.type)
    ])
    error_message = "Record type must be one of: A, AAAA, CNAME, MX, TXT, PTR, SRV, SOA, NS."
  }

  validation {
    condition = alltrue([
      for key, record in var.dns_records :
      record.zone != null && length(record.zone) > 0
    ])
    error_message = "Zone is required for all DNS records."
  }

  validation {
    condition = alltrue([
      for key, record in var.dns_records :
      record.zone_type == null || try(contains(["public", "private"], record.zone_type), false)
    ])
    error_message = "Zone type must be either 'public', 'private', or null (for auto-discovery)."
  }
}
