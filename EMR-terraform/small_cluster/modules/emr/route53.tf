data "aws_route53_zone" "emr_zone" {
  count = "${var.create_dns ? 1 : 0}"
  name  = "${var.dns_zone}"
}

resource "aws_route53_record" "emr_dns" {
  count   = "${var.create_dns ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.emr_zone.*.zone_id[count.index]}"
  name    = "emr.${var.name}.${data.aws_route53_zone.emr_zone.*.name[count.index]}"
  type    = "A"
  ttl     = "60"
  records = ["${replace(aws_emr_cluster.emr.master_public_dns, "/ip-([0-9]*)-([0-9]*)-([0-9]*)-([0-9]*).*/", "$1.$2.$3.$4")}"]
}
