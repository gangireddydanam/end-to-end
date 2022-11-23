
resource "aws_lb" "siva-test-alb" {
  name               = "siva-test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.siva-alb-sg.id]
  subnets            = ["subnet-06a4fe8de348be0d0","subnet-0d9ead0517eed6690"]

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "siva-alb"
  }
}

resource "aws_lb_target_group" "siva-tg-bastion" {
  name     = "tg-bastion"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0c2607d15e39a1ef0"
}

resource "aws_lb_target_group_attachment" "siva-tg-attachment-bastion" {
  target_group_arn = aws_lb_target_group.siva-tg-bastion.arn
  target_id        = aws_instance.bastion.id
  port             = 80
}


# resource "aws_lb_target_group" "siva-tg-tomcat" {
#   name     = "tg-tomcat"
#   port     = 8080
#   protocol = "HTTP"
#   vpc_id   = "vpc-0b8a10a9f3969a588"
# }

# resource "aws_lb_target_group_attachment" "siva-tg-attachment-tomcat" {
#   target_group_arn = aws_lb_target_group.siva-tg-tomcat.arn
#   target_id        = aws_instance.tomcat.id
#   port             = 8080
# }


resource "aws_lb_listener" "siva-alb-listener" {
  load_balancer_arn = aws_lb.siva-test-alb.arn
  port              = "80"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.siva-tg-bastion.arn
  }
}

# resource "aws_lb_listener_rule" "siva-jenkins-hostbased" {
#   listener_arn = aws_lb_listener.siva-alb-listener.arn
# #   priority     = 99

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.siva-tg-jenkins.arn
#   }

#   condition {
#     host_header {
#       values = ["jenkins.siva.quest"]
#     }
#   }
# }

# resource "aws_lb_listener_rule" "siva-tomcat-hostbased" {
#   listener_arn = aws_lb_listener.siva-alb-listener.arn
# #   priority     = 98

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.siva-tg-tomcat.arn
#   }

#   condition {
#     host_header {
#       values = ["tomcat.siva.quest"]
#     }
#   }
# }