# resource "aws_security_group" "siva-alb-sg" {
#   name        = "alb-sg"
#   description = "this is using for securitygroup"
#   vpc_id      = "vpc-0c2607d15e39a1ef0"

# #   ingress {
# #     description = "this is inbound rule"
# #     from_port   = 22
# #     to_port     = 22
# #     protocol    = "tcp"
# #     cidr_blocks = ["103.110.170.84/32"]
# #   }
#   ingress {
#     description = "this is inbound rule"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "all"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "siva-alb-sg"
#   }
# }

resource "aws_security_group" "siva-alb-sg" {
  name        = "alb-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0c2607d15e39a1ef0"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  #   ingress {
  #   description = "this is inbound rule"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "all"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "siva-alb-sg"
  }
}