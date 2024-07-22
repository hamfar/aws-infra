resource "aws_cloudwatch_log_group" "saasbackups_log_group" {
  name = "awslogs-saasbackups-${var.environment}"

  tags = {
    Environment = var.environment
    Application = "SaaSBackups"
  }
}