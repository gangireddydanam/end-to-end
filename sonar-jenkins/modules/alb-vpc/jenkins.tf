resource "aws_instance" "cicd" {
  ami           = "ami-0b89f7b3f054b957e"
  instance_type = var.instance_type
  #vpc_id = aws_vpc.vpc.id
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.cicd.id]
#   iam_instance_profile = aws_iam_instance_profile.artifactory.name
  key_name               = "${var.instance-keypair-name}"
   user_data              = <<-EOF
              #!/bin/bash
              wget -O /etc/yum.repos.d/jenkins.repo \
              https://pkg.jenkins.io/redhat-stable/jenkins.repo
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              yum update -y
              amazon-linux-extras install java-openjdk11
              yum install jenkins -y
              systemctl start jenkins
              EOF

  tags = {
    Name = "Dev-cicd"
  }
}