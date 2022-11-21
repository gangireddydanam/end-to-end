#configure aws provider
provider "aws" {
  region = var.region
}

#create vpc
module "vpc" {
  source = "../template/vpc/"
  region = var.region
  project_name = var.project_name
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr = var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_subnet_az1_cidr
  private_subnet_az2_cidr = var.private_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr

}

