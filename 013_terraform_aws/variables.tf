# Variables
variable "domain_name" {
  default     = "patrickaziken.me"
  type        = string
  description = "Terraform sub-domain"
}


# varibale the calls from the terraform.tfvars file I added by Adeoluwa
variable "access_key" {
  description = "AWS Access Key"
  default     = [{}]
}

variable "secret_key" {
  description = "AWS Secret Key"
  default     = [{}]
}
