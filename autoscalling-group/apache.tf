resource "aws_security_group" "apache" {
  name        = "apache"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.stag-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
    ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "apache"
  }
}

resource "aws_instance" "apache" {
  ami                       = "ami-0de5311b2a443fb89"
  instance_type             = "t2.micro"
  subnet_id                 = aws_subnet.stag-private1[0].id
  vpc_security_group_ids    = [aws_security_group.apache.id]
  key_name                  = "my-own-key"
  user_data                 = <<EOF
  #!/bin/bash
sudo su -
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
systemctl status httpd
  EOF

  tags ={
    name= "apache"

  }
}




# # apache-security
# resource "aws_security_group" "apache2" {
#   name        = "apache2"
#   description = "Allow  inbound traffic"
#   vpc_id      = aws_vpc.stag-vpc.id

#   ingress {
#     description      = "from admin"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }
# ingress {
#     description      = "from admin"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "apache2" 
    
#   }
# }

# resource "aws_instance" "apache2" {
#   ami                    = "ami-06489866022e12a14"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.stag-public1[0].id
#   vpc_security_group_ids = [aws_security_group.apache2.id]
#   key_name               = aws_key_pair.pavan1.id
#   user_data              = <<-EOF
#  #!/bin/bash
#  yum update -y 
#  yum install httpd -y 
#  systemctl start httpd
#  systemctl enable httpd
#   EOF


#    tags = {
#     Name = "apache2"
#   }
# }