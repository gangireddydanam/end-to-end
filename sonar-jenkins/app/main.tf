module "alb" {
  source = "../modules/alb-vpc"
#   cidr_block       = var.vpc-cidr
#   name               = var.alb-name
#   load_balancer_type = var.lb-type
#   instance_type = var.instance_type
#   key_name               = "${var.instance-keypair-name}"
}
