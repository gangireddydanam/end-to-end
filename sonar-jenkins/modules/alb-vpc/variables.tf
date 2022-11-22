variable "name"{
    type=string
    default="alb"
}
variable "lb-type"{
    type=string
    default="application"
}
variable "vpc-cidr"{
    default="10.0.0.0/16"
}
variable "instance-keypair-name"{
    type=string
    default = "demo"
}
variable "instance_type"{
    default = "t2.medium"
}








