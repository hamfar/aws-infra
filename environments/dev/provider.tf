provider "aws" {
  region = var.aws_region
  alias = "main"
  profile = "default"
}

provider "aws" {
  profile = "backup"
  alias = "backup"
  region = var.aws_region
}

provider "onepassword" {
  service_account_token = "token"
}