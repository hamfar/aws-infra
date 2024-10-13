resource "aws_security_group" "ecs_sched_sg" {
  name        = "ecs_sched-sg${var.suffix}"
  vpc_id      = var.vpc_id


}

resource "aws_vpc_security_group_egress_rule" "ecs_sched_outbound_internet" {
  security_group_id = aws_security_group.ecs_sched_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}

resource "aws_vpc_security_group_ingress_rule" "ecs_sched_inbound_https" {
  security_group_id = aws_security_group.ecs_sched_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}