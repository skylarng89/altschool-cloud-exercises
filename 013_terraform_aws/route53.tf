# Create Route53 domain name
resource "aws_route53_zone" "main" {
  name = var.domain_names.domain_name
}

# Create Route53 subdomain
resource "aws_route53_record" "subdomain" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_names.subdomain_name
  type    = "A"

  alias {
    name                   = aws_lb.altschool-ex13-lb.dns_name
    zone_id                = aws_lb.altschool-ex13-lb.zone_id
    evaluate_target_health = true
  }
}
