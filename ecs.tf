resource "aws_ecs_cluster" "staging" {
  name = "saasbackup-cluster"
}

data "template_file" "saasbackup" {
  template = file("./saasapp.json.tpl")
  vars = {
    aws_ecr_repository = aws_ecr_repository.repo.repository_url
    tag                = "latest"
    app_port           = 80
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "saasbackup-staging"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.saasbackup.rendered
  tags = {
    Environment = "staging"
    Application = "saasbackup"
  }
}

resource "aws_ecs_service" "staging" {
  name            = "staging"
  cluster         = aws_ecs_cluster.staging.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    security_groups = [aws_security_group.saasbackup.id]
    subnets         = aws_subnet.private_subnets.*.id
  }
  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role, aws_ecs_cluster.staging]

  tags = {
    Environment = "staging"
    Application = "SaaSBackups"
  }
}

resource "aws_cloudwatch_log_group" "SaaSBackups" {
  name = "awslogs-saasbackups-staging"

  tags = {
    Environment = "staging"
    Application = "SaaSBackup"
  }
}