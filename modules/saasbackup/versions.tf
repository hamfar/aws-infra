terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6.0" 
      configuration_aliases = [aws.main, aws.backup]
    }
  }
}