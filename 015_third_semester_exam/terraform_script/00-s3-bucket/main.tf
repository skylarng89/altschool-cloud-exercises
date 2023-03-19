provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "altschool-africa-s3"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Terraform = "true"
  }
}
