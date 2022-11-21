resource "aws_instance" "bastion" {

  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.own_key.id
  subnet_id     = aws_subnet.public_subnet1.id

  security_groups = [aws_security_group.bastion-sg.id]
}