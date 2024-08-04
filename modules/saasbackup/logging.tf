resource "aws_cloudwatch_log_group" "saasbackups_log_group" {
  name = "awslogs-saasbackups${var.suffix}"
  retention_in_days = 7

  tags = {
    Environment = var.environment
    Application = "SaaSBackups"
  }
}