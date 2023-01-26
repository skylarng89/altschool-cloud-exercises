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

# Create a VPC
resource "aws_vpc" "altschool-ex13-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "altschool-ex13-vpc"
  }
}

# Create route table
resource "aws_route_table" "altschool-ex13-rtable" {
  vpc_id = aws_vpc.altschool-ex13-vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.altschool-ex13.id
  }

  tags = {
    Name = "altschool-ex13-rtable"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "altschool-ex13-igw" {
  vpc_id = aws_vpc.altschool-ex13-vpc.id

  tags = {
    Name = "altschool-ex13-igw"
  }
}

# Create subnets
resource "aws_subnet" "altschool-ex13-subneta" {
  vpc_id                                         = aws_vpc.altschool-ex13-vpc.id
  cidr_block                                     = "10.1.0.0/24"
  availability_zone                              = "eu-west-2a"
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
  enable_resource_name_dns_aaaa_record_on_launch = true
  map_public_ip_on_launch                        = true

  tags = {
    Name = "altschool-ex13-subnetc"
  }
}

# Network Access Control
resource "aws_network_acl" "altschool-ex13-acl" {
  vpc_id     = aws_vpc.altschool-ex13-vpc.id
  subnet_ids = [aws_subnet.altschool-ex13-subneta.id, aws_subnet.altschool-ex13-subnetb.id, aws_subnet.altschool-ex13-subnetc.id]

  egress {
    protocol   = "tcp"
    rule_no    = 100
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
    from_port   = 80
    to_port     = 80
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

# Create EC2 security groups
resource "aws_security_group" "altschool-ex13-ec2sg" {
  name        = "altschool-ex13-ec2sg"
  description = "EC2 instances security group"
  vpc_id      = aws_vpc.altschool-ex13-vpc.id
  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.altschool-ex13-loadbalancersg.id]
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
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "altschool-ex13-ec2sg"
  }
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
    Name   = "altschool-ex13-server1"
    source = "terraform"
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
    Name   = "altschool-ex13-server2"
    source = "terraform"
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
    Name   = "altschool-ex13-server3"
    source = "terraform"
  }
}
