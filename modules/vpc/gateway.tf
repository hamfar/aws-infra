#resource "aws_internet_gateway" "ig" {
#  vpc_id = aws_vpc.vpc.id
#}

#resource "aws_eip" "nat_eip" {
#  depends_on = [aws_internet_gateway.ig]
#}

#resource "aws_nat_gateway" "nat" {
#  allocation_id = aws_eip.nat_eip.id
#  subnet_id     = element(aws_subnet.public_subnets.*.id, 0)
#}