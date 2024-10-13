resource "aws_cloudwatch_event_rule" "ecs_sched_cron" {
  name                = "ecs_sched-cron${var.suffix}"
  schedule_expression = "cron(*/3 * * * ? *)"  
}


resource "aws_cloudwatch_event_target" "ecs_sched_ecs_scheduled_task" {
  target_id = "ecs_sched-daily-schedule${var.suffix}"
  arn       = aws_ecs_cluster.ecs_sched_ecs_cluster.arn
  rule      = aws_cloudwatch_event_rule.ecs_sched_cron.name
  role_arn  = aws_iam_role.ecs_sched_ecs_events.arn

  ecs_target {
    task_count          = 1
    launch_type         = "FARGATE"
    task_definition_arn = aws_ecs_task_definition.ecs_sched_ecs_task_definition.arn
    network_configuration {
       subnets = var.subnet
       security_groups = [aws_security_group.ecs_sched_sg.id]
       assign_public_ip = false
    }
  }
}