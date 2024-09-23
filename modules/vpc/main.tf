resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "aws-infra-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnets_cidr)
 vpc_id     = aws_vpc.vpc.id
 cidr_block = element(var.public_subnets_cidr, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnets_cidr)
 vpc_id     = aws_vpc.vpc.id
 cidr_block = element(var.private_subnets_cidr, count.index)
 map_public_ip_on_launch = false
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

#resource "aws_subnet" "default_private_subnet" {
#  count = var.default_private_subnet_index == 0 ? 1 : 0 
 # vpc_id = aws_vpc.vpc.id
 # cidr_block  = element(var.private_subnets_cidr, var.default_private_subnet_index)
#  availability_zone = element(var.azs, var.default_private_subnet_index)
#  map_public_ip_on_launch = false 
#  tags = {
#    Name = "Default Private Subnet"
#  }
#}