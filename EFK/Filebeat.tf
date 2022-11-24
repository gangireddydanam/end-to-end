#security_group
resource "aws_security_group" "Fb-sg" {
  name        = "fb-sg"
  description = "Allow inbound traffic"
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
    from_port        = 8080
    to_port          = 8080
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
resource "aws_instance" "Fb" {
  ami           = "ami-07651f0c4c315a529"
  instance_type = "t2.large"
  availability_zone = data.aws_availability_zones.available.names[0]
  key_name = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.Fb-sg.id]
	user_data = "${file("fb-user-data.sh")}"
   
  tags = {
    Name = "Fb"
  }
}
