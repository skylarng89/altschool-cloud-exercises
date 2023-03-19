terraform {
  backend "s3" {
    bucket  = "altschool-africa-s3"
    key     = "terraform.tfstate"
    encrypt = true
    region  = "eu-west-2"
  }
}


