
module "vpc" {
    source = "../vpccode"
    publicsubnet = var.publicsubnet
    privatesubnet = var.privatesubnet
    datasubnet = var.datasubnet
    az = var.az
}

# resource "aws_instance" "apache" {
#     ami = var.ami
#     instance_type = var.instance_type
  
# }


module "ec2" {
    source = "../ec2-alb"
  
}

# module "alb" {
#     source = "../alb"
  
# }

