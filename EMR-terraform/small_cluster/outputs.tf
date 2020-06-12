output "id" {
  value = "aws_emr_cluster.emr.id"
}

output "name" {
  value = "aws_emr_cluster.emr.name"
}

output "master_public_dns" {
  value = "aws_emr_cluster.emr.master_public_dns"
}

output "dns_name" {
  value = "aws_route53_record.emr_dns.*.name"
}
