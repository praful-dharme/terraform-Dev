module "vpc" {

  source = "./modules/vpc"

  vpc_cidr = "10.10.0.0/16"

  public_subnets = [
    "10.10.1.0/24",
    "10.10.2.0/24"
  ]

  private_subnets = [
    "10.10.3.0/24",
    "10.10.4.0/24"
  ]

  azs = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

module "security_group" {

  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id
}

module "iam" {

  source = "./modules/iam"
}

module "launch_template" {

  source = "./modules/launch-template"

  instance_profile_name = module.iam.instance_profile_name

  security_group_id = module.security_group.ec2_sg_id

  key_name = "may"
}

module "autoscaling" {

  source = "./modules/autoscaling"

  launch_template_id      = module.launch_template.launch_template_id
  launch_template_version = module.launch_template.launch_template_latest_version
  private_subnet_ids      = module.vpc.private_subnet_ids
}

module "alb" {

  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  alb_sg_id         = module.security_group.alb_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
  asg_name          = module.autoscaling.asg_name
}

module "rds" {

  source = "./modules/rds"

  private_subnet_ids = module.vpc.private_subnet_ids

  rds_sg_id = module.security_group.rds_sg_id

  db_username = var.db_username

  db_password = var.db_password
}


