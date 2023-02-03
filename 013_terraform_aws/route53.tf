# Create hosted zone - Route53
resource "aws_route53_zone" "terraform-hosted-zone" {
  name = var.domain_name
  tags = {
    Environment = "prod"
  }
}

# Create sub-domain 'A' record
resource "aws_route53_record" "terraform_domain" {
  zone_id = aws_route53_zone.terraform-hosted-zone.id
  name    = "terraform.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.altschool-ex13-lb.id
    zone_id                = aws_lb.altschool-ex13-lb.zone_id
    evaluate_target_health = true
  }
}
