resource "aws_cloudwatch_event_rule" "saasbackup_cron" {
  name                = "example-event-rule"
  schedule_expression = "cron(* * * * ? *)"  
}


resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  target_id = "run-scheduled-task-every-hour"
  arn       = aws_ecs_cluster.ecs_cluster.arn
  rule      = aws_cloudwatch_event_rule.saasbackup_cron.name
  role_arn  = aws_iam_role.saasbackups_ecs_events.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.saasbackup-definition.arn
  }
}