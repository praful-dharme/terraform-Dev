output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnet_ids
}

output "private_subnets" {
  value = module.vpc.private_subnet_ids
}

output "alb_sg_id" {
  value = module.security_group.alb_sg_id
}

output "ec2_sg_id" {
  value = module.security_group.ec2_sg_id
}

output "rds_sg_id" {
  value = module.security_group.rds_sg_id
}

output "instance_profile_name" {
  value = module.iam.instance_profile_name
}

output "launch_template_id" {
  value = module.launch_template.launch_template_id
}

output "asg_name" {
  value = module.autoscaling.asg_name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

