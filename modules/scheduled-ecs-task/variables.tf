variable "environment" {
  type = string
}

variable "suffix" {
  description = "suffix to add to aws resource names"
  type = string
  default = "-01"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_id" {
    description = "vpc id for fargate cluster"
    type = string
}

variable "subnet" {
  description = "Subnet Fargate cluster to be deployed to"
  type = list(string)
}

variable "application_name" {
  description = "Name of application to be run on a scheduled task"
  type = string
  default = "ecs-sched-task"
}