resource "aws_secretsmanager_secret" "ecs_sched_secrets" {
  name = "ecs_sched-secrets${var.suffix}"
  recovery_window_in_days = 0
}