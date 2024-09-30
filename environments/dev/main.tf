module "vpc" {
  source = "../../modules/vpc"
  public_subnets_cidr = ["10.0.17.0/24"]
  private_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  azs = ["eu-west-1a"]

}

module "saasbackups" {
  source = "../../modules/saasbackup"
  s3_bucket_auto = "ecs-saasbackups-dev"
  s3_bucket_manual = "saasbackups-dev"
  environment = var.environment
  aws_region = var.aws_region
  vpc_id = module.vpc.vpc_id
  subnet = module.vpc.private_subnet_id[*]
  providers = {
    aws.main = aws.main
    aws.backup = aws.backup
  }
}



#resource "aws_db_instance" "my_rds_instance" {
#  allocated_storage    = 20
#  storage_type         = "gp2"
#  engine               = "mysql"
#  engine_version       = "8.0"
#  instance_class       = "db.t2.micro"
  
#  db_name                 = "test1db-hamfar"
#  username             = "useradmin"
#  password = "password"
 # password             = onepassword_item.my_rds_password.password
#}

#resource "onepassword_item" "my_rds_password" {
#  vault = ""
#  title = "RDS Password"

#  password_recipe {
#    length  = 28
#    symbols = true
#  }

#}
