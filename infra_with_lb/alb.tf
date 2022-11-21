resource "aws_lb" "anand-test-alb" {
  name               = "anand-test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-07fc75f18b021e675","subnet-005c09e3a25cdb35c","subnet-085ea20a65f64a514"]

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "anand-alb"
  }
}

resource "aws_lb_target_group" "anand-tg-jenkins" {
  name     = "tg-jenkins"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc1.id
}

resource "aws_lb_target_group_attachment" "anand-tg-attachment-jenkins" {
  target_group_arn = aws_lb_target_group.anand-tg-jenkins.arn
  target_id        = aws_instance.jeknins.id
  port             = 8080
}


resource "aws_lb_target_group" "anand-tg-tomcat" {
  name     = "tg-tomcat"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc1.id
}

resource "aws_lb_target_group_attachment" "anand-tg-attachment-tomcat" {
  target_group_arn = aws_lb_target_group.anand-tg-tomcat.arn
  target_id        = aws_instance.tomcat.id
  port             = 8080
}

resource "aws_lb_target_group" "anand-tg-apache" {
  name     = "tg-apache"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc1.id
}

resource "aws_lb_target_group_attachment" "anand-tg-attachment-apache" {
  target_group_arn = aws_lb_target_group.anand-tg-apache.arn
  target_id        = aws_instance.apache.id
  port             = 80
}


resource "aws_lb_listener" "anand-alb-listener" {
  load_balancer_arn = aws_lb.anand-test-alb.arn
  port              = "80"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.anand-tg-jenkins.arn
  }
}

resource "aws_lb_listener_rule" "anand-jenkins-hostbased" {
  listener_arn = aws_lb_listener.anand-alb-listener.arn
#   priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.anand-tg-jenkins.arn
  }

  condition {
    host_header {
      values = ["jenkins.anand.quest"]
    }
  }
}

resource "aws_lb_listener_rule" "anand-tomcat-hostbased" {
  listener_arn = aws_lb_listener.anand-alb-listener.arn
#   priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.anand-tg-tomcat.arn
  }

  condition {
    host_header {
      values = ["tomcat.anand.quest"]
    }
  }
}

resource "aws_lb_listener_rule" "anand-apache-hostbased" {
  listener_arn = aws_lb_listener.anand-alb-listener.arn
#   priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.anand-tg-apache.arn
  }

  condition {
    host_header {
      values = ["apache.anand.quest"]
    }
  }
}