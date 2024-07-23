
data "aws_iam_policy_document" "saasbackups_ecs_data_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "saasbackups_ecs_task_execution_role" {
  name = "saasbackups-ecs-task-execution${var.suffix}"
  assume_role_policy = data.aws_iam_policy_document.saasbackups_ecs_data_policy.json
}

resource "aws_iam_policy_attachment" "saasbackups_ecs_task_execution_policy" {
  name = "saasbackups-policy-attachment"
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
  name               = "saasbackups-ecs-events${var.suffix}"
  assume_role_policy = data.aws_iam_policy_document.saasbackups_events_assume_role.json
}


data "aws_iam_policy_document" "saasbackups_events_run_task_policy" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.saasbackups_ecs_task_execution_role.arn]
    condition {
      test  = "StringLike"
      variable = "iam:PassedToService"
      values = ["ecs-tasks.amazonaws.com"]
    }
  }
  
  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["${aws_ecs_task_definition.saasbackups_ecs_task_definition.arn_without_revision}:*"]
    condition {
      test = "ArnEquals"
      variable = "ecs:cluster"
      values = [aws_ecs_cluster.saasbackups_ecs_cluster.arn]
    }
  }
}

resource "aws_iam_role_policy" "saasbackups_events_run_task" {
  name   = "saasbackups-events-run-task${var.suffix}"
  role   = aws_iam_role.saasbackups_ecs_events.id
  policy = data.aws_iam_policy_document.saasbackups_events_run_task_policy.json
}


data "aws_iam_policy_document" "saasbackups_secrets_data_policy" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetResourcePolicy",
                  "secretsmanager:GetSecretValue",
                  "secretsmanager:DescribeSecret",
                  "secretsmanager:ListSecretVersionIds",
                  "secretsmanager:ListSecrets"]
    resources = [aws_secretsmanager_secret.saasbackups_secrets.id]
  }
}


resource "aws_iam_role_policy" "saasbackups_secrets_policy" {
  name   = "saasbackups-secrets${var.suffix}"
  role   = aws_iam_role.saasbackups_ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.saasbackups_secrets_data_policy.json
}


data "aws_iam_policy_document" "saasbackups_s3_data_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.saasbackups_s3_bucket_auto.arn}/*", aws_s3_bucket.saasbackups_s3_bucket_auto.arn]
  }
}

resource "aws_iam_role_policy" "saasbackups_s3_policy" {
  name   = "saasbackups-s3-policy"
  role   = aws_iam_role.saasbackups_ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.saasbackups_s3_data_policy.json
}


