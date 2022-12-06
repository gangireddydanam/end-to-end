output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "ek_pub_ip" {
  value = aws_instance.ek.public_ip
}

output "fb_pub_ip" {
  value = aws_instance.Fb.public_ip
}

# output "fingerprint" {
#   value = data.aws_key_pair.key.fingerprint
# }

# output "foo" {
#   value = data.aws_vpc.selected.id
# }