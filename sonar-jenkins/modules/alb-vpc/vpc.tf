data "aws_availability_zones" "available" {
  state = "available"
}

#vpc
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "Dev-vpc"
    Terraform = "true"
  }
}

#public-subnets
resource "aws_subnet" "public" {
  count= length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"], count.index)
  map_public_ip_on_launch = "true"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Dev-public-${count.index+1}"
  }
}

#private-subnets

resource "aws_subnet" "private" {
  count= length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"], count.index)
  availability_zone= element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Dev-private-${count.index+1}"
  }
}

#data-subnets

# resource "aws_subnet" "data" {
#   count= length(data.aws_availability_zones.available.names)
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = element(["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"], count.index)
#   availability_zone = data.aws_availability_zones.available.names[count.index]

#   tags = {
#     Name = "data${count.index+1}"
#   }
# }
#ig
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Dev-igw"
  }
}
#ngw

resource "aws_eip" "eip" {
  vpc      = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "Dev-ngw"
  }

  depends_on = [
    aws_eip.eip
  ]
}


#routetables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Dev-public-route"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "Dev-private-route"
  }
}

#associates

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public[*])
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private[*])
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

# resource "aws_route_table_association" "data" {
#   count = length(aws_subnet.data[*])
#   subnet_id      =element(aws_subnet.data[*].id, count.index)
#   route_table_id = aws_route_table.private.id
# }