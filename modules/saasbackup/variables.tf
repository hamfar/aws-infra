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

variable "s3_bucket_auto" {
  description = "bucket to be used to store automated SaaSBackups"
  type = string
  default = "ecs-saasbackups"
}

variable "s3_bucket_manual" {
  description = "bucket to be used to store manual SaaSBackups"
  type = string
  default = "saasbackups" 

}