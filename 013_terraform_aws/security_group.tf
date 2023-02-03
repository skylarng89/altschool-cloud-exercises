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
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.altschool-ex13-ec2sg.id, aws_security_group.altschool-ex13-loadbalancersg.id]
}
resource "aws_network_interface" "altschool-ex13-ni-2" {
  subnet_id       = aws_subnet.altschool-ex13-subnetb.id
  private_ips     = ["10.0.2.50"]
  security_groups = [aws_security_group.altschool-ex13-ec2sg.id, aws_security_group.altschool-ex13-loadbalancersg.id]
}
resource "aws_network_interface" "altschool-ex13-ni-3" {
  subnet_id       = aws_subnet.altschool-ex13-subnetc.id
  private_ips     = ["10.0.3.50"]
  security_groups = [aws_security_group.altschool-ex13-ec2sg.id, aws_security_group.altschool-ex13-loadbalancersg.id]
}

