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


# apache:
resource "aws_instance" "apache" {
  ami                    = "ami-072bfb8ae2c884cc4"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.stag-public1[0].id
  vpc_security_group_ids = [aws_security_group.apache.id]
  key_name               = "pavan"
 




  tags = {
    Name = "apache"
  }
}