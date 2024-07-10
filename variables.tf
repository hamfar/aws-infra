variable "public_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.128.0/24"]
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.16.0/24", "10.0.144.0/24"]
  description = "CIDR block for Private Subnet"
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["eu-west-1a", "eu-west-1b"]
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