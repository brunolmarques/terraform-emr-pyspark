terraform {
  backend "s3" {
    encrypt = true
    bucket  = "gympass-bi-terraform-state"
    key     = "emr/terraform.tfstate"
    region  = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_subnet" "private_1a" {
  tags = {
    Name = "data-default-us-east-1a-private"
  }
}

module "emr" {
  source                            = "./modules/emr/"
  name                              = "${var.name}"
  key_name                          = "${var.key_name}"
  subnet_id                         = "${data.aws_subnet.private_1a.id}"
  create_dns                        = true
  dns_zone                          = "data.us.gympass.cloud."

}

output "emr_dns_name" {
  value                  = "${module.emr.dns_name}"
  description            = "EMR Cluster DNS"
}
