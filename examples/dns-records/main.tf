module "dns_records" {
  source = "../../src//dns-records"

  dns_records = {
    "tmp.aws.dmfigol.me|A" : { "name" : "tmp.aws.dmfigol.me", "type" : "A", "zone" : "aws.dmfigol.me", "records": ["1.1.1.1"]},
    "tmp.aws.dmfigol.me|AAAA" : { "name" : "tmp.aws.dmfigol.me", "type" : "AAAA", "zone" : "aws.dmfigol.me", "records": ["2001:4860:4860::8888"]},
    "tmp-cname.aws.dmfigol.me" : { "type" : "CNAME", "zone" : "aws.dmfigol.me", "records": ["tmp.aws.dmfigol.me"]},  # if name is not provided, assume it is the key
    "tmp-alias.aws.dmfigol.me" : { "type" : "A", "zone" : "aws.dmfigol.me", "alias": {"name": "tmp.aws.dmfigol.me"} },  # will assume alias zone id to be the same as zone
  }
}
