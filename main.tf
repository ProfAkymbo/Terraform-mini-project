# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Akymbo-vpc"
  }
}

# Create Public Subnet-1
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Akymbo-public-subnet1"
  }
}

# Create Public Subnet-2
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Akymbo-public-subnet2"
  }
}

# Network interface to allow traffics to subnets 
resource "aws_network_acl" "network_acl" {
  vpc_id     = aws_vpc.example.id
  subnet_ids = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.example.id
  tags = {
    "Name" = "Akymbo-gateway"
  }
}

# Create public Route Table
resource "aws_route_table" "route-table-public" {
  vpc_id = aws_vpc.example.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Akymbo-route-table-public"
  }
}

# Associate public subnet 1 with public route table
resource "aws_route_table_association" "public-subnet1-association" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.route-table-public.id
}

# Associate public subnet 2 with public route table
resource "aws_route_table_association" "subnet2-association" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.route-table-public.id
}

