# Create an Application Load Balancer
resource "aws_lb" "load-balancer" {
  name               = "Akymbo-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
  #enable_cross_zone_load_balancing = true
  enable_deletion_protection = false
  depends_on                 = [aws_instance.server-1, aws_instance.server-2, aws_instance.server-3]
}

# Create a security group for the load balancer
resource "aws_security_group" "load_balancer_sg" {
  name        = "Akymbo-load-balancer-sg"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.example.id

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

# Create Security Group to allow port 22, 80 and 443
resource "aws_security_group" "security-grp-rule" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP and HTTPS inbound traffic for instances"
  vpc_id      = aws_vpc.example.id

 ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.load_balancer_sg.id]
  }
 ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.load_balancer_sg.id]
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
    Name = "security-grp-rule"
  }
}

# Create the target group
resource "aws_lb_target_group" "target-group" {
  name     = "Akymbo-target-group"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example.id
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

# Create the listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

# Create the listener rule
resource "aws_lb_listener_rule" "listener-rule" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# Attach the target group to the load balancer
resource "aws_lb_target_group_attachment" "target-group-attachment1" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.server-1.id
  port             = 80
}
 
resource "aws_lb_target_group_attachment" "target-group-attachment2" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.server-2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "target-group-attachment3" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.server-3.id
  port             = 80 
  }