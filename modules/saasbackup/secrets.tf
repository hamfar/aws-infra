resource "aws_secretsmanager_secret" "saasbackups_secrets" {
  name = "saasbackups-secrets${var.suffix}"
  recovery_window_in_days = 0
}