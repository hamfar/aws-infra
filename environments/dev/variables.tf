variable "environment" {
  type = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "deployed_env" {
  description = "Environment to be deployed - dev/stage/prod"
  type = string 
  default = "dev"
}

