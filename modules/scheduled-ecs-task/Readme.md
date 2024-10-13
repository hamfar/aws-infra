# Terraform Module: AWS ECS scheduled task infrastructure

This Terraform module sets up an AWS ECS cluster, creates a task definition, and schedules a container to perform run a container on schedule. It also provisions necessary AWS resources such as S3 buckets and IAM policies to manage SaaS backups.

## Usage

```hcl
module "saasbackups" {
  source = "../../modules/saasbackup"
  s3_bucket_auto = "ecs-saasbackups-dev"
  s3_bucket_manual = "saasbackups-dev"
  environment = var.environment
  suffix  = "-01"
  region = var.aws_region
  vpc_id = module.vpc.vpc_id
  subnet = module.vpc.private_subnet_id[*]
}
```

## Requirements

- AWS provider plugin `terraform init` 