<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_records"></a> [dns\_records](#input\_dns\_records) | DNS records configuration | <pre>map(object({<br/>    name    = optional(string, null)<br/>    type    = string<br/>    records = optional(list(string))<br/>    ttl     = optional(number, 300)<br/>    alias = optional(object({<br/>      name                   = string<br/>      zone_id                = optional(string, null)<br/>      evaluate_target_health = optional(bool, true)<br/>    }))<br/>    zone      = string<br/>    zone_type = optional(string, null) # can be private, public or null (auto-discovery)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_records"></a> [records](#output\_records) | Map of all created DNS records |
<!-- END_TF_DOCS -->