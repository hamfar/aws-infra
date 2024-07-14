module "vpc" {
  source = "../../modules/vpc"
  public_subnets_cidr = ["10.0.17.0/24"]
  private_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  azs = ["eu-west-1a"]

}

module "saasbackups" {
  source = "../../modules/saasbackup"
  environment = var.environment
  region = var.aws_region
  vpc_id = module.vpc.vpc_id
  subnet = module.vpc.private_subnet_id[*]
}