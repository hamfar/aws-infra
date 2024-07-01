
terraform {
  backend "s3" {
    bucket         = "tfm-infra-state-hamfar"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}