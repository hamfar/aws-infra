
resource "aws_vpc" "test-infra" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "test-infra"
  }
}

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnets_cidr)
 vpc_id     = aws_vpc.test-infra.id
 cidr_block = element(var.public_subnets_cidr, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnets_cidr)
 vpc_id     = aws_vpc.test-infra.id
 cidr_block = element(var.private_subnets_cidr, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}