##############################################
# Networking Module
##############################################

module "networking" {
  source = "./modules/networking"

  project_name             = var.project_name
  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_web_subnet_cidrs = var.private_web_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

##############################################
# Security Module
##############################################

module "security" {

  source = "./modules/security"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.networking.vpc_id

}

##############################################
# IAM Module
##############################################

module "iam" {

  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment

}

##############################################
# EC2 Launch Template Module
##############################################


module "ec2" {

  source = "./modules/ec2"

  project_name = var.project_name

  environment = var.environment

  instance_profile_name = module.iam.instance_profile_name

  ec2_security_group_id = module.security.ec2_security_group_id

  instance_type = var.instance_type

}

##############################################
# Application Load Balancer Module
##############################################

module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id

  health_check_path = var.health_check_path
}

##############################################
# Auto Scaling Module
##############################################

module "autoscaling" {

  source = "./modules/autoscaling"

  project_name = var.project_name

  environment = var.environment

  private_web_subnet_ids = module.networking.private_web_subnet_ids

  launch_template_id = module.ec2.launch_template_id

  launch_template_version = module.ec2.launch_template_latest_version

  target_group_arn = module.alb.target_group_arn

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

}

##############################################
# Amazon RDS Module
##############################################

module "rds" {

  source = "./modules/rds"

  project_name = var.project_name

  environment = var.environment

  private_db_subnet_ids = module.networking.private_db_subnet_ids

  rds_security_group_id = module.security.rds_security_group_id

  db_name = var.db_name

  db_username = var.db_username

  db_password = var.db_password

  db_instance_class = var.db_instance_class

  allocated_storage = var.allocated_storage

  engine_version = var.engine_version

}