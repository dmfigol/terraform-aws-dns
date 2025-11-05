module "dns_records" {
  source = "../../src/dns-records"

  dns_records = var.test_dns_records
}

variable "test_dns_records" {}