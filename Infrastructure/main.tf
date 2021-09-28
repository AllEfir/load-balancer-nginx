provider "aws" {
  region = var.aws_region
}
resource "aws_instance" "load-balancer" {
  ami = "ami-07df274a488ca9195"
  instance_type = "t2.micro"
  key_name = "makentosh-key"
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sgr.id]
  tags = {
    name = "nginx-load-balancer"
  }
}
resource "aws_instance" "nginx1" {
  ami = "ami-07df274a488ca9195"
  instance_type = "t2.micro"
  key_name = "makentosh-key"
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sgr.id]
  tags = {
    name = "nginx1"
  }
}
resource "aws_instance" "nginx2" {
  ami = "ami-07df274a488ca9195"
  instance_type = "t2.micro"
  key_name = "makentosh-key"
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sgr.id]
  tags = {
    name = "nginx2"
  }
}
resource "aws_vpc" "vpc-nginx" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "vpc-nginx"
    CidrBlock = "172.16.1.0/24"
  }
}
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc-nginx.id
  tags = {
    Name = "gateway-nginx"
  }
}
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc-nginx.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
  tags = {
    Name = "Route table"
  }
}
resource "aws_route_table_association" "route_association" {
  route_table_id = aws_route_table.route.id
  subnet_id = aws_subnet.subnet.id
}
resource "aws_subnet" "subnet" {
  cidr_block = "172.16.1.0/24"
  vpc_id = aws_vpc.vpc-nginx.id
  availability_zone = "eu-central-1a"
  tags = {
    Name = "subnet"
    cidr_block = "172.16.1.0/24"
  }
  map_public_ip_on_launch = true
}
resource "aws_security_group" "sgr" {
  name = "redis and nginx"
  vpc_id = aws_vpc.vpc-nginx.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "securitygroupfromnginx"
  }
}
