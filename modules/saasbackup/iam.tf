resource "aws_iam_role" "saasbackups_ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "saasbackups_ecs_task_execution_policy" {
  name = "saasbackups_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.saasbackups_ecs_task_execution_role.name]
}


data "aws_iam_policy_document" "saasbackups_events_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "saasbackups_ecs_events" {
  name               = "saasbackups_ecs_events"
  assume_role_policy = data.aws_iam_policy_document.saasbackups_events_assume_role.json
}


data "aws_iam_policy_document" "saasbackups_events_run_task_with_any_role" {
  statement {


    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = [aws_ecs_task_definition.saasbackup-definition.arn_without_revision]
  }
}

resource "aws_iam_role_policy" "saasbackups_events_run_task_with_any_role" {
  name   = "ecs_events_run_task_with_any_role"
  role   = aws_iam_role.saasbackups_ecs_events.id
  policy = data.aws_iam_policy_document.saasbackups_events_run_task_with_any_role.json
}


