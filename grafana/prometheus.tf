resource "aws_security_group" "prometheus1" {
  name        = "prometheus1"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0ad1244df6b5fa72e"

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
    from_port        = 9090
    to_port          = 9090
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
    Name = "prometheus1"
  }
}
resource "aws_instance" "prometheus1" {
  ami                       = "ami-0de5311b2a443fb89"
  instance_type             = "t2.micro"
  subnet_id                 = "subnet-0037e88756b401595"
  vpc_security_group_ids    = [aws_security_group.prometheus1.id]
  key_name                  = "my-own-key"
  user_data                 = <<EOF
  #!/bin/bash
  sudo su -
  wget https://github.com/prometheus/prometheus/releases/download/v2.39.1/prometheus-2.39.1.linux-amd64.tar.gz
  tar -xvzf prometheus-2.39.1.linux-amd64.tar.gz
  cd prometheus-2.39.1.linux-amd64/
  ./prometheus
  EOF

  tags ={
    name ="prometheus1"
    }
}