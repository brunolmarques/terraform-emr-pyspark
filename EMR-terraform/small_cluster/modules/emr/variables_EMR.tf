# EMR
variable "name" {}

variable "key_name" {}

variable "subnet_id" {}

variable "emr_managed_master_security_group" {
  type    = string
  default = "ElasticMapReduce-Master-Private"
}

variable "emr_managed_slave_security_group" {
  type    = string
  default = "ElasticMapReduce-Slave-Private"
}

variable "service_access_security_group" {
  type    = string
  default = "ElasticMapReduce-ServiceAccess"
}

variable "instance_profile" {
  type    = string
  default = "EMR_EC2_DefaultRole"
}

# route53
variable "create_dns" {}
variable "dns_zone" {}
