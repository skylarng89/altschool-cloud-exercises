# Terraform provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}


# Create VPC
resource "aws_vpc" "miniproject13-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "miniproject13-vpc"
  }
}


# Create Subnets
resource "aws_subnet" "miniproject13-subnet-1" {
  vpc_id                  = aws_vpc.miniproject13-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "miniproject13-subnet-1"
  }
}

resource "aws_subnet" "miniproject13-subnet-2" {
  vpc_id                  = aws_vpc.miniproject13-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"
  tags = {
    Name = "miniproject13-subnet-2"
  }
}

resource "aws_subnet" "miniproject13-subnet-3" {
  vpc_id                  = aws_vpc.miniproject13-vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2c"
  tags = {
    Name = "miniproject13-subnet-3"
  }
}


# Create Internet Gateway
resource "aws_internet_gateway" "miniproject13-igw" {
  vpc_id = aws_vpc.miniproject13-vpc.id
  tags = {
    Name = "miniproject13-igw"
  }
}


# Create Route Table
resource "aws_route_table" "miniproject13-rt-pub" {
  vpc_id = aws_vpc.miniproject13-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.miniproject13-igw.id
  }
  tags = {
    Name = "miniproject13-rt-pub"
  }
}


# Associate Subnets to Route Table
resource "aws_route_table_association" "miniproject13-rta-pub-1" {
  subnet_id      = aws_subnet.miniproject13-subnet-1.id
  route_table_id = aws_route_table.miniproject13-rt-pub.id
}

resource "aws_route_table_association" "miniproject13-rta-pub-2" {
  subnet_id      = aws_subnet.miniproject13-subnet-2.id
  route_table_id = aws_route_table.miniproject13-rt-pub.id
}

resource "aws_route_table_association" "miniproject13-rta-pub-3" {
  subnet_id      = aws_subnet.miniproject13-subnet-3.id
  route_table_id = aws_route_table.miniproject13-rt-pub.id
}


# Create Network Access Control List
resource "aws_network_acl" "miniproject13-nacl" {
  vpc_id     = aws_vpc.miniproject13-vpc.id
  subnet_ids = [aws_subnet.miniproject13-subnet-1.id, aws_subnet.miniproject13-subnet-2.id]
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "miniproject13-nacl"
  }
}


# Create Load Balancer security group
resource "aws_security_group" "miniproject13-sg-lb" {
  name        = "miniproject13-sg-lb"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.miniproject13-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create Security Groups
resource "aws_security_group" "miniproject13-ec2-sg" {
  name        = "miniproject13-ec2-sg"
  description = "Allow SSH, HTTP"
  vpc_id      = aws_vpc.miniproject13-vpc.id
  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.miniproject13-sg-lb.id]
  }
  ingress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.miniproject13-sg-lb.id]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "miniproject13-ec2-sg"
  }
}


# Create EC2 instances
resource "aws_instance" "miniproject13-server1" {
  ami               = "ami-00de6c6491fdd3ef5"
  instance_type     = "t2.micro"
  key_name          = "miniproject13"
  security_groups   = [aws_security_group.miniproject13-ec2-sg.id]
  subnet_id         = aws_subnet.miniproject13-subnet-1.id
  availability_zone = "eu-west-2a"
  tags = {
    Name   = "miniproject13-server1"
    source = "terraform"
  }
}

resource "aws_instance" "miniproject13-server2" {
  ami               = "ami-00de6c6491fdd3ef5"
  instance_type     = "t2.micro"
  key_name          = "miniproject13"
  security_groups   = [aws_security_group.miniproject13-ec2-sg.id]
  subnet_id         = aws_subnet.miniproject13-subnet-2.id
  availability_zone = "eu-west-2b"
  tags = {
    Name   = "miniproject13-server2"
    source = "terraform"
  }
}

resource "aws_instance" "miniproject13-server3" {
  ami               = "ami-00de6c6491fdd3ef5"
  instance_type     = "t2.micro"
  key_name          = "miniproject13"
  security_groups   = [aws_security_group.miniproject13-ec2-sg.id]
  subnet_id         = aws_subnet.miniproject13-subnet-3.id
  availability_zone = "eu-west-2c"
  tags = {
    Name   = "miniproject13-server3"
    source = "terraform"
  }
}


# Create load balancer
resource "aws_lb" "miniproject13-lb" {
  name                       = "miniproject13-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.miniproject13-sg-lb.id]
  subnets                    = [aws_subnet.miniproject13-subnet-1.id, aws_subnet.miniproject13-subnet-2.id]
  enable_deletion_protection = false
  depends_on                 = [aws_instance.miniproject13-server1, aws_instance.miniproject13-server2, aws_instance.miniproject13-server3]
}


# Create load balancer target group
resource "aws_lb_target_group" "miniproject13-tg" {
  name        = "miniproject13-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.miniproject13-vpc.id
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


# Create load balancer listener
resource "aws_lb_listener" "miniproject13-listener" {
  load_balancer_arn = aws_lb.miniproject13-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.miniproject13-tg.arn
  }
}


# Create the listener rule
resource "aws_lb_listener_rule" "miniproject13-listener-rule" {
  listener_arn = aws_lb_listener.miniproject13-listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.miniproject13-tg.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}


# Attache instances to load balancer
resource "aws_lb_target_group_attachment" "miniproject13-tg_attachment_1" {
  target_group_arn = aws_lb_target_group.miniproject13-tg.arn
  target_id        = aws_instance.miniproject13-server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "miniproject13-tg_attachment_2" {
  target_group_arn = aws_lb_target_group.miniproject13-tg.arn
  target_id        = aws_instance.miniproject13-server2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "miniproject13-tg_attachment_3" {
  target_group_arn = aws_lb_target_group.miniproject13-tg.arn
  target_id        = aws_instance.miniproject13-server3.id
  port             = 80
}


# Create hosted zone - Route53
resource "aws_route53_zone" "host-zone" {
  name = var.domain_names.domain_name
}


# Create terraform sub-domain 'A' record
resource "aws_route53_record" "miniproject13-domain" {
  zone_id = aws_route53_zone.host-zone.id
  name    = var.domain_names.subdomain_name
  type    = "A"
  alias {
    name                   = aws_lb.miniproject13-lb.dns_name
    zone_id                = aws_lb.miniproject13-lb.zone_id
    evaluate_target_health = true
  }
}


# Variables
variable "domain_names" {
  type        = map(string)
  description = "Terraform subdomain"
}

variable "access_key" {
  description = "AWS Access Key"
  default     = [{}]
}

variable "secret_key" {
  description = "AWS Secret Key"
  default     = [{}]
}


# Write IPs to local file
resource "local_file" "host-inventory" {
  filename = "host_inventory"
  content  = <<EOT
[all]
${aws_instance.miniproject13-server1.public_ip}
${aws_instance.miniproject13-server2.public_ip}
${aws_instance.miniproject13-server3.public_ip}
  EOT
}
