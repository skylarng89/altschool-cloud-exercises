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
  vpc_id                                      = aws_vpc.altschool-ex13-vpc.id
  cidr_block                                  = "10.0.1.0/24"
  availability_zone                           = "eu-west-2a"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = true

  tags = {
    Name = "altschool-ex13-subneta"
  }
}

resource "aws_subnet" "altschool-ex13-subnetb" {
  vpc_id                                      = aws_vpc.altschool-ex13-vpc.id
  cidr_block                                  = "10.0.2.0/24"
  availability_zone                           = "eu-west-2b"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = true

  tags = {
    Name = "altschool-ex13-subnetb"
  }
}

resource "aws_subnet" "altschool-ex13-subnetc" {
  vpc_id                                      = aws_vpc.altschool-ex13-vpc.id
  cidr_block                                  = "10.0.3.0/24"
  availability_zone                           = "eu-west-2c"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = true

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
