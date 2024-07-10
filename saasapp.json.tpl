[
  {
    "name": "saasbackup",
    "image": "${aws_ecr_repository}:${tag}",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "saasbackups-$environment-service",
        "awslogs-group": "awslogs-saasbackups-${environment}"
      }
    },
    "portMappings": [
      {
        "containerPort": 4000,
        "hostPort": 4000,
        "protocol": "tcp"
      }
    ],
    "cpu": 1,
    "environment": [
      {
        "name": "NODE_ENV",
        "value": "${environment}"
      },
      {
        "name": "PORT",
        "value": "4000"
      }
    ],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 65536,
        "hardLimit": 65536
      }
    ],
    "mountPoints": [],
    "memory": 1024,
    "volumesFrom": []
  }
]