data "aws_security_group" "master" {
  filter {
      name   = "tag:Name"
      values = ["${var.emr_managed_master_security_group}"]
    }
}

data "aws_security_group" "slave" {
  filter {
      name   = "tag:Name"
      values = ["${var.emr_managed_slave_security_group}"]
    }
}

data "aws_security_group" "service_access" {
  filter {
      name   = "tag:Name"
      values = ["${var.service_access_security_group}"]
    }
}
