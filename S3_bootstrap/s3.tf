resource "aws_s3_bucket" "terraform_state" {
  bucket = "gympass-ml-bootstrap-scripts"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name      = "bootstrap scripts"
    service   = "s3-bucket"
    terraform = "true"
    env       = "bi"
    area      = "machine-learning"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = "${aws_s3_bucket.terraform_state.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "bootstrap_action_file" {
  bucket     = "${aws_s3_bucket.terraform_state.id}"
  key        = "scripts/emr_bootstrap.sh"
  source     = "scripts/emr_bootstrap.sh"
  depends_on = ["aws_s3_bucket.terraform_state"]
}
