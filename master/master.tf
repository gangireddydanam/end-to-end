resource "aws_security_group" "master" {
  name        = "master"
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
    from_port        = 8080
    to_port          = 8080
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
    Name = "master"
  }
}


# master:
resource "aws_instance" "master" {
  ami                    = "ami-072bfb8ae2c884cc4"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.stag-public1[0].id
  vpc_security_group_ids = [aws_security_group.master.id]
  key_name               = "pavan"
  user_data              = <<-EOF
 #!/bin/bash
 sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
 sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
 yum install epel-release # repository that provides 'daemonize'
 amazon-linux-extras install epel
 amazon-linux-extras install java-openjdk11 -y
#  yum install java-11-openjdk-devel
 yum install jenkins -y
 systemctl start jenkins
 systemctl enable jenkins
  EOF



  tags = {
    Name = "master"
  }
}