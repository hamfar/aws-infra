terraform {
  required_providers {
    aws = { 
      source = "hashicorp/aws"
      version = ">= 4.6.0"
    }
  }

  required_version = ">= 1.4"

  backend "s3" {
    bucket         = "tfm-infra-state-hamfar"
    key            = "dev/saasbackups.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }   
}