variable "environment" {
  type = string
}

variable "region" {
  type = string
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