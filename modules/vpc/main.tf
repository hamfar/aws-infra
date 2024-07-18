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
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}



