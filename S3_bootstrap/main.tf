terraform {
  backend "s3" {
    bucket = "gympass-bi-terraform-state"
    key    = "S3_buckets/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
