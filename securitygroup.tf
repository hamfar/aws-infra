resource "aws_security_group" "saasbackup" {
  name        = "saasbackup-security-group"
  vpc_id      = aws_vpc.test-infra.id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}