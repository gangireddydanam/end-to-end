
# alb 

resource "aws_lb" "alb" {
  name               = "Dev-alb"
  internal           = false
  load_balancer_type = var.lb-type
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.bucket
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
      Name        = "Dev-alb"

    }
}

#tg 
resource "aws_lb_target_group" "sonarqube" {
  name     = "sonarqube-tg"
  port     = "9000"
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/"
    port                = "9000"
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200" # has to be HTTP 200 or fails
  }
}
resource "aws_lb_target_group" "jenkins" {
  name     = "jenkins-tg"
  port     = "8080"
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/"
    port                = "8080"
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200" # has to be HTTP 200 or fails
  }
}

#listener 
resource "aws_lb_listener" "sonarqube" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube.arn
  }
}
# resource "aws_lb_listener" "jenkins" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "8080"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.jenkins.arn
#   }
# }

resource "aws_lb_target_group_attachment" "sonarqube" {
  target_group_arn = aws_lb_target_group.sonarqube.arn
  target_id        = aws_instance.sonarqube.id
  port             = "9000"
}
resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = aws_lb_target_group.jenkins.arn
  target_id        = aws_instance.cicd.id
  port             = "8080"
}