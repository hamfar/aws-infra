
data "aws_iam_policy_document" "ecs_sched_ecs_data_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_sched_ecs_task_execution_role" {
  name = "ecs_sched-ecs-task-execution${var.suffix}"
  assume_role_policy = data.aws_iam_policy_document.ecs_sched_ecs_data_policy.json
}

resource "aws_iam_policy_attachment" "ecs_sched_ecs_task_execution_policy" {
  name = "ecs_sched-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_sched_ecs_task_execution_role.name]
}

data "aws_iam_policy_document" "ecs_sched_events_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_sched_ecs_events" {
  name               = "ecs_sched-ecs-events${var.suffix}"
  assume_role_policy = data.aws_iam_policy_document.ecs_sched_events_assume_role.json
}


data "aws_iam_policy_document" "ecs_sched_events_run_task_policy" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.ecs_sched_ecs_task_execution_role.arn]
    condition {
      test  = "StringLike"
      variable = "iam:PassedToService"
      values = ["ecs-tasks.amazonaws.com"]
    }
  }
  
  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["${aws_ecs_task_definition.ecs_sched_ecs_task_definition.arn_without_revision}:*"]
    condition {
      test = "ArnEquals"
      variable = "ecs:cluster"
      values = [aws_ecs_cluster.ecs_sched_ecs_cluster.arn]
    }
  }
}

resource "aws_iam_role_policy" "ecs_sched_events_run_task" {
  name   = "ecs_sched-events-run-task${var.suffix}"
  role   = aws_iam_role.ecs_sched_ecs_events.id
  policy = data.aws_iam_policy_document.ecs_sched_events_run_task_policy.json
}


data "aws_iam_policy_document" "ecs_sched_secrets_data_policy" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetResourcePolicy",
                  "secretsmanager:GetSecretValue",
                  "secretsmanager:DescribeSecret",
                  "secretsmanager:ListSecretVersionIds",
                  "secretsmanager:ListSecrets"]
    resources = [aws_secretsmanager_secret.ecs_sched_secrets.id]
  }
}


resource "aws_iam_role_policy" "ecs_sched_secrets_policy" {
  name   = "ecs_sched-secrets${var.suffix}"
  role   = aws_iam_role.ecs_sched_ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.ecs_sched_secrets_data_policy.json
}

