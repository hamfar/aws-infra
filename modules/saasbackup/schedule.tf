resource "aws_cloudwatch_event_rule" "saasbackups_cron" {
  name                = "saasbackups-cron${var.suffix}"
  schedule_expression = "cron(*/3 * * * ? *)"  
}


resource "aws_cloudwatch_event_target" "saasbackups_ecs_scheduled_task" {
  target_id = "saasbackups-daily-schedule${var.suffix}"
  arn       = aws_ecs_cluster.saasbackups_ecs_cluster.arn
  rule      = aws_cloudwatch_event_rule.saasbackups_cron.name
  role_arn  = aws_iam_role.saasbackups_ecs_events.arn

  ecs_target {
    task_count          = 1
    launch_type         = "FARGATE"
    task_definition_arn = aws_ecs_task_definition.saasbackups_ecs_task_definition.arn
    network_configuration {
       subnets = var.subnet
       security_groups = [aws_security_group.saasbackups_sg.id]
       assign_public_ip = false
    }
  }
}