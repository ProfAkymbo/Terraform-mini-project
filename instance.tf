# creating instance 1
resource "aws_instance" "server-1" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  key_name        = "aws-key"
 
  security_groups = [aws_security_group.security-grp-rule.id]
  subnet_id       = aws_subnet.public-subnet1.id
  availability_zone = "us-east-1a"
  tags = {
    Name   = "server-1"
    source = "terraform"
  }
}

# creating instance 2
 resource "aws_instance" "server-2" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  key_name        = "aws-key"
  
  security_groups = [aws_security_group.security-grp-rule.id]
  subnet_id       = aws_subnet.public-subnet2.id
  availability_zone = "us-east-1b"
  tags = {
    Name   = "server-2"
    source = "terraform"
  }
}

# creating instance 3
resource "aws_instance" "server-3" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  key_name        = "aws-key"
  
  security_groups = [aws_security_group.security-grp-rule.id]
  subnet_id       = aws_subnet.public-subnet1.id
  availability_zone = "us-east-1a"
  tags = {
    Name   = "server-3"
    source= "terraform"
  }
}

# Create a file to store the IP addresses of the instances
resource "local_file" "Ip_address" {
  filename = "/terraform-mini-project/inventory-file"
  content  = <<EOT
${aws_instance.server-1.public_ip}
${aws_instance.server-2.public_ip}
${aws_instance.server-3.public_ip}
  EOT
}



