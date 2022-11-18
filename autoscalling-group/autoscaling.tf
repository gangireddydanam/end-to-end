# resource "aws_launch_template" "ami" {
#   name_prefix   = "ami"
#   image_id      = "aws_ami_from_instance" "apache-ami"
#   instance_type = "t2.micro"
# }

# resource "aws_autoscaling_group" "ami-backup" {
#   availability_zones = [ap-northeast-1]
#   desired_capacity   = 1
#   max_size           = 1
#   min_size           = 1

#   launch_template {
#     id      = aws_launch_template.ami.id
#     version = "$Latest"
#   }
# }



# resource "aws_launch_template" "pavan" {
#   name_prefix   = "pavan"
#   image_id      = aws_ami_from_instance.apache-ami.id
#   instance_type = "t2.micro"
# }

# resource "aws_autoscaling_group" "pavan" {
#   availability_zones = ["ap-northeast-1"]
#   desired_capacity   = 2
#   max_size           = 2
#   min_size           = 2

#   launch_template {
#     id      = aws_launch_template.pavan.id
#     version = "$Latest"
#   }
# }



# resource "aws_launch_template" "example" {
#   name_prefix   = "example"
#   image_id      = aws_ami_from_instance.apache-ami.id
#   instance_type = "c5.large"
# }

# resource "aws_autoscaling_group" "example" {
#   availability_zones = ["us-east-1a"]
#   desired_capacity   = 1
#   max_size           = 5
#   min_size           = 1

#   warm_pool {
#     pool_state                  = "Hibernated"
#     min_size                    = 1
#     max_group_prepared_capacity = 10

#     instance_reuse_policy {
#       reuse_on_scale_in = true
#     }
#   }
# }




 resource "aws_launch_template" "autoscaling" {
   name_prefix   = "terraform"
   image_id      = aws_ami_from_instance.apache-ami.id
   instance_type = "t2.micro"
   key_name = "my-own-key"

 }

 resource "aws_autoscaling_group" "autoscaling" {
   availability_zones = ["ap-northeast-1a","ap-northeast-1c"]
   desired_capacity   = 4
   max_size           = 6
   min_size           = 1

 launch_template {
     id      = aws_launch_template.autoscaling.id
     version = "$Latest"
   }

  
 }