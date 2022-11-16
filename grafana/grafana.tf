resource "aws_security_group" "grafana" {
  name        = "grafana"
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
    from_port        = 3000
    to_port          = 3000
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
    Name = "grafana"
  }
}

resource "aws_instance" "grafana" {
  ami                       = "ami-0de5311b2a443fb89"
  instance_type             = "t2.micro"
  subnet_id                 = "subnet-0037e88756b401595"
  vpc_security_group_ids    = [aws_security_group.grafana.id]
  key_name                  = "my-own-key"
  user_data                 = <<EOF
  #!/bin/bash
  sudo su -
cd /opt
wget https://dl.grafana.com/oss/release/grafana-9.2.1.linux-amd64.tar.gz
tar -xvzf grafana-9.2.1.linux-amd64.tar.gz
chmod -R 755 grafana-9.2.1
cd grafana-9.2.1/bin/
nohup ./grafana-server &
  EOF

  tags ={
    name= "grafana"

  }
}