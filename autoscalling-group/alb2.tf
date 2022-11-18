resource "aws_lb_target_group" "my-target-group1" {
   health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name     = "target-group1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.stag-vpc.id
}


# Create Security Group for the Application Load Balancer
# terraform aws create security group
resource "aws_security_group" "alb-security-group" {
  name        = "ALB Security Group"
  description = "Enable HTTP/HTTPS access on Port 80/443"
  vpc_id      = aws_vpc.stag-vpc.id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "HTTPS Access"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group"
  }
}
resource "aws_lb" "loadbalencer1" {
  name               = "test-lb-tf1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-security-group.id]
  subnets            = ["${aws_subnet.stag-public1[0].id}", "${aws_subnet.stag-public1[1].id}"]

  enable_deletion_protection = true

  

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group_attachment" "application1" {
  # target_group_arn = "aws:elasticloadbalancing:ap-south-1:340567388318:targetgroup/my-test-tg/a02c39f384960b79"
  target_group_arn = aws_lb_target_group.my-target-group1.arn
  target_id        = aws_instance.apache.id
  port             = 80

}

# Load Balancer Listener
resource "aws_lb_listener" "alblistener" {
  load_balancer_arn = aws_lb.loadbalencer1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-target-group1.arn
  }
}