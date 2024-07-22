resource "aws_ecs_cluster" "saasbackups_ecs_cluster" {
  name = "saasbackup-cluster-${var.environment}"
    
  tags = {
    Environment = var.environment
    Application = "SaaSBackups"
  }
}

resource "aws_ecs_task_definition" "saasbackups_ecs_task_definition" {
  family                   = "saasbackups"
  execution_role_arn       = aws_iam_role.saasbackups_ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.saasbackups_ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = "256"  
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  volume  {
    name = "githubDir"
  }

  volume {
    name = "rootHome"
  }

  volume {
    name = "archiveDir"
  }
  container_definitions = <<TASK_DEFINITION
  [
    {
      "name": "saasbackup",
      "image": "busybox",
      "command": ["ls -h /backups"],
      "essential": true,
      "mountPoints" : [
        { "sourceVolume": "githubDir",
          "containerPath": "/backup/github"
        },
        { "sourceVolume": "rootHome",
          "containerPath": "/root/.ssh"
        },
        { "sourceVolume": "archiveDir",
          "containerPath": "/backup/archive"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.environment}",
          "awslogs-group": "awslogs-saasbackups-${var.environment}"
        }
      },
      "portMappings": [],
      "cpu": 1,
      "environment": [],
      "ulimits": [
        {
          "name": "nofile",
          "softLimit": 65536,
          "hardLimit": 65536
        }
      ],
      "memory": 1024,
      "ephemeralStorage": {
        "sizeInGiB": 200
      }
    }
  ]
  TASK_DEFINITION 
}
