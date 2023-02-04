# AWS Provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "eu-west-2"
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

# Exporting the IP Addresses from the EC2 Instances in a file
resource "local_file" "host-inventory" {
  content = <<-DOC
    [webservers]
    ${aws_instance.altschool-ex13-server1.public_ip}
    ${aws_instance.altschool-ex13-server2.public_ip}
    ${aws_instance.altschool-ex13-server3.public_ip}

    [webservers:vars]
    ansible_ssh_user=ubuntu
    ansible_ssh_private_key_file=~/.ssh/altschool-ex13.pem
    ansible_ssh port=22
    DOC

  filename             = "/ansible/hosts"
  directory_permission = "0755"
  file_permission      = "0775"
}
