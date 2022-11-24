# output "zones" {
#   value = data.aws_availability_zones.available.names
# }

# output "vpcname" {
#   value = aws_vpc.stag-vpc.id
# }

# output "countofaz" {
#   value = length(data.aws_availability_zones.available.names)
# }
output "masterip" {
  value = aws_instance.master.public_ip

}

output "slaveip" {
  value = aws_instance.slave.public_ip
  
}

output "slavepubdns" {
  value = aws_instance.slave.public_dns
  
}

output "masterpubdns" {
  value = aws_instance.master.public_dns
  
}