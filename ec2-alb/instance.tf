resource "aws_instance" "bastion" {
  ami                    = "ami-0d593311db5abb72b"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-06a4fe8de348be0d0"
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name = "ram"
   tags = {
    Name = "stage-bastion"
  }
}