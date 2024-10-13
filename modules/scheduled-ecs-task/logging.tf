resource "aws_cloudwatch_log_group" "ecs_sched_log_group" {
  name = "awslogs-ecs_sched${var.suffix}"
  retention_in_days = 7

  tags = {
    Environment = var.environment
    Application = var.application_name
  }
}