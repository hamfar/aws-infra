resource "aws_ecr_repository" "ecs_sched_repo" {
  name = "ecs_sched/${var.environment}-${var.suffix}"
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = var.environment
    Application = var.application_name
  }
}

resource "aws_ecr_lifecycle_policy" "ecs_sched_repo_policy" {
  repository = aws_ecr_repository.ecs_sched_repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep image deployed with tag latest",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["latest"],
        "countType": "imageCountMoreThan",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 2 any images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 2
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}