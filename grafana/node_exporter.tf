resource "aws_security_group" "node-exporter" {
  name        = "node-exporter"
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
    from_port        = 9100
    to_port          = 9100
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
    Name = "node-exporter"
  }
}

resource "aws_instance" "node-exporter" {
  ami                       = "ami-0de5311b2a443fb89"
  instance_type             = "t2.micro"
  subnet_id                 = "subnet-0037e88756b401595"
  vpc_security_group_ids    = [aws_security_group.node-exporter.id]
  key_name                  = "my-own-key"
  user_data                 = <<EOF
  #!/bin/bash
  sudo su -
  yum install -y
cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
 tar -zvxf node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
 cd node_exporter-1.4.0-rc.0.linux-amd64/
./node_exporter
nohup ./node_exporter &
EOF

tags ={
  name ="node-exporter"
 }
}