terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Variables
variable "domain_name" {
  default     = "patrickaziken.me"
  type        = string
  description = "Terraform sub-domain"
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

# Create a VPC
resource "aws_vpc" "altschool-ex13-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "altschool-ex13-vpc"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "altschool-ex13-igw" {
  vpc_id = aws_vpc.altschool-ex13-vpc.id

  tags = {
    Name = "altschool-ex13-igw"
  }
}

# Create route table
resource "aws_route_table" "altschool-ex13-rtable" {
  vpc_id = aws_vpc.altschool-ex13-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.altschool-ex13-igw.id
  }

  tags = {
    Name = "altschool-ex13-rtable"
  }
}

# Create subnets
resource "aws_subnet" "altschool-ex13-subneta" {
  vpc_id                                         = aws_vpc.altschool-ex13-vpc.id
  cidr_block                                     = "10.1.0.0/24"
  availability_zone                              = "eu-west-2a"
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  map_public_ip_on_launch                        = true

  tags = {
    Name = "altschool-ex13-subneta"
  }
}

resource "aws_subnet" "altschool-ex13-subnetb" {
  vpc_id                                         = aws_vpc.altschool-ex13-vpc.id
  cidr_block                                     = "10.2.0.0/24"
  availability_zone                              = "eu-west-2b"
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  map_public_ip_on_launch                        = true

  tags = {
    Name = "altschool-ex13-subnetb"
  }
}

resource "aws_subnet" "altschool-ex13-subnetc" {
  vpc_id                                         = aws_vpc.altschool-ex13-vpc.id
  cidr_block                                     = "10.3.0.0/24"
  availability_zone                              = "eu-west-2c"
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  map_public_ip_on_launch                        = true

  tags = {
    Name = "altschool-ex13-subnetc"
  }
}

# Subnet to route table association
resource "aws_route_table_association" "altschool-ex13-rta-1" {
  subnet_id      = aws_subnet.altschool-ex13-subneta.id
  route_table_id = aws_route_table.altschool-ex13-rtable.id
}
resource "aws_route_table_association" "altschool-ex13-rta-2" {
  subnet_id      = aws_subnet.altschool-ex13-subnetb.id
  route_table_id = aws_route_table.altschool-ex13-rtable.id
}
resource "aws_route_table_association" "altschool-ex13-rta-3" {
  subnet_id      = aws_subnet.altschool-ex13-subnetc.id
  route_table_id = aws_route_table.altschool-ex13-rtable.id
}

# Network Access Control
resource "aws_network_acl" "altschool-ex13-acl" {
  vpc_id     = aws_vpc.altschool-ex13-vpc.id
  subnet_ids = [aws_subnet.altschool-ex13-subneta.id, aws_subnet.altschool-ex13-subnetb.id, aws_subnet.altschool-ex13-subnetc.id]

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "altschool-ex13-acl"
  }
}

# Create Load Balancer Security Group
resource "aws_security_group" "altschool-ex13-loadbalancersg" {
  name        = "altschool-ex13-loadbalancersg"
  description = "Load balancer security group"
  vpc_id      = aws_vpc.altschool-ex13-vpc.id
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 security groups
resource "aws_security_group" "altschool-ex13-ec2sg" {
  name        = "altschool-ex13-ec2sg"
  description = "EC2 instances security group"
  vpc_id      = aws_vpc.altschool-ex13-vpc.id
  ingress {
    description     = "Allow HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.altschool-ex13-loadbalancersg.id]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "altschool-ex13-ec2sg"
  }
}

# Create network interface
resource "aws_network_interface" "altschool-ex13-ni-1" {
  subnet_id       = aws_subnet.altschool-ex13-subneta.id
  private_ips     = ["10.1.1.50"]
  security_groups = [aws_security_group.altschool-ex13-ec2sg.id, aws_security_group.altschool-ex13-loadbalancersg.id]
}
resource "aws_network_interface" "altschool-ex13-ni-2" {
  subnet_id       = aws_subnet.altschool-ex13-subnetb.id
  private_ips     = ["10.2.1.50"]
  security_groups = [aws_security_group.altschool-ex13-ec2sg.id, aws_security_group.altschool-ex13-loadbalancersg.id]
}
resource "aws_network_interface" "altschool-ex13-ni-3" {
  subnet_id       = aws_subnet.altschool-ex13-subnetc.id
  private_ips     = ["10.3.1.50"]
  security_groups = [aws_security_group.altschool-ex13-ec2sg.id, aws_security_group.altschool-ex13-loadbalancersg.id]
}

# Create EC2 instances
resource "aws_instance" "altschool-ex13-server1" {
  ami               = "ami-00de6c6491fdd3ef5"
  instance_type     = "t2.micro"
  key_name          = "altschool-ex13"
  security_groups   = [aws_security_group.altschool-ex13-ec2sg.id]
  subnet_id         = aws_subnet.altschool-ex13-subneta.id
  availability_zone = "eu-west-2a"
  tags = {
    Name = "altschool-ex13-server1"
  }
}
resource "aws_instance" "altschool-ex13-server2" {
  ami               = "ami-00de6c6491fdd3ef5"
  instance_type     = "t2.micro"
  key_name          = "altschool-ex13"
  security_groups   = [aws_security_group.altschool-ex13-ec2sg.id]
  subnet_id         = aws_subnet.altschool-ex13-subnetb.id
  availability_zone = "eu-west-2b"
  tags = {
    Name = "altschool-ex13-server2"
  }
}
resource "aws_instance" "altschool-ex13-server3" {
  ami               = "ami-00de6c6491fdd3ef5"
  instance_type     = "t2.micro"
  key_name          = "altschool-ex13"
  security_groups   = [aws_security_group.altschool-ex13-ec2sg.id]
  subnet_id         = aws_subnet.altschool-ex13-subnetc.id
  availability_zone = "eu-west-2c"
  tags = {
    Name = "altschool-ex13-server3"
  }
}

# Create ALB target group
resource "aws_lb_target_group" "altschool-ex13-lb-tg" {
  name        = "altschool-ex13-lb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.altschool-ex13-vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create Load balancer
resource "aws_lb" "altschool-ex13-lb" {
  name                       = "altschool-ex13-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.altschool-ex13-loadbalancersg.id]
  subnets                    = [aws_subnet.altschool-ex13-subneta.id, aws_subnet.altschool-ex13-subnetb.id, aws_subnet.altschool-ex13-subnetc.id]
  enable_deletion_protection = false
  depends_on                 = [aws_instance.altschool-ex13-server1, aws_instance.altschool-ex13-server2, aws_instance.altschool-ex13-server3]
}

# Create target listener
resource "aws_lb_listener" "altschool-ex13-listener" {
  load_balancer_arn = aws_lb.altschool-ex13-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  }
}
# Create target listener rule
resource "aws_lb_listener_rule" "altschool-ex13-listener-rule" {
  listener_arn = aws_lb_listener.altschool-ex13-listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# Attach LB target group
resource "aws_lb_target_group_attachment" "altschool-ex13-att1" {
  target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  target_id        = aws_instance.altschool-ex13-server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Altschool-target-group-attachment2" {
  target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  target_id        = aws_instance.altschool-ex13-server2.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "Altschool-target-group-attachment3" {
  target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  target_id        = aws_instance.altschool-ex13-server3.id
  port             = 80

}

# Create hosted zone - Route53
resource "aws_route53_zone" "terraform-hosted-zone" {
  name = var.domain_name
  tags = {
    Environment = "prod"
  }
}

# Create terraform sub-domain 'A' record
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
