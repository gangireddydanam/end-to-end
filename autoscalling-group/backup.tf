resource "aws_ami_from_instance" "apache-ami" {
  name               = "terraform-apache-ami"
  source_instance_id = aws_instance.apache.id
}