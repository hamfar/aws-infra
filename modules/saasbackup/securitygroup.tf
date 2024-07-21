resource "aws_security_group" "saasbackups_sg" {
  name        = "saasbackups-sg-${var.environment}"
  vpc_id      = var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}