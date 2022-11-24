#availability_zone
data "aws_availability_zones" "available" {
  state = "available"
}
#key_pair
data "aws_key_pair" "key" {
  key_name           = "demo"
  include_public_key = true
}
#my_ip
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

#security_group
resource "aws_security_group" "ek-sg" {
  name        = "ek-sg"
  description = "Allow  inbound traffic"
  vpc_id      = "vpc-09b4d10534029a0c8"

  ingress {
    description      = "admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    description      = "admin"
    from_port        = 5601
    to_port          = 5601
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "admin"
    from_port        = 9200
    to_port          = 9200
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "efk-sg"
  }
}
#instance
resource "aws_instance" "ek" {
  ami           = "ami-07651f0c4c315a529"
  instance_type = "t2.2xlarge"
  availability_zone = data.aws_availability_zones.available.names[0]
  key_name = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.ek-sg.id]
	user_data = "${file("ek-user-data.sh")}"
   
  tags = {
    Name = "ek"
  }
}