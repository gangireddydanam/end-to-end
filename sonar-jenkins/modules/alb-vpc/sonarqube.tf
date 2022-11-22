
resource "aws_instance" "sonarqube" {
  ami           = "ami-0b89f7b3f054b957e"
  instance_type = var.instance_type
  #vpc_id = aws_vpc.vpc.id
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.sonar.id]
  key_name               = "${var.instance-keypair-name}"
  user_data              = <<-EOF
             #!/bin/bash
             amazon-linux-extras install java-openjdk11 -y
             cd /opt
             wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip
             unzip sonarqube-8.9.10.61524.zip
             useradd sonaradmin
             chown -R sonaradmin:sonaradmin /opt/sonarqube-8.9.10.61524
             sudo su -c '/opt/sonarqube-8.9.10.61524/bin/linux-x86-64/sonar.sh start' sonaradmin
              EOF
         
  tags = {
    Name = "Dev-sonarqube"
  }
}

