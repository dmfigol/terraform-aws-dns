data "aws_route53_zones" "all" {}

data "aws_route53_zone" "all" {
  for_each = toset(data.aws_route53_zones.all.ids)

  zone_id = each.key
}
