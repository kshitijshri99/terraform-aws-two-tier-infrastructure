##############################################
# Networking Outputs
##############################################

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_web_subnet_ids" {
  description = "Private web subnet IDs"
  value       = module.networking.private_web_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = module.networking.private_db_subnet_ids
}

##############################################
# Security Outputs
##############################################

output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = module.security.alb_security_group_id
}

output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = module.security.ec2_security_group_id
}

output "rds_security_group_id" {
  description = "RDS Security Group ID"
  value       = module.security.rds_security_group_id
}

##############################################
# IAM Outputs
##############################################

output "instance_profile_name" {
  description = "EC2 IAM Instance Profile"
  value       = module.iam.instance_profile_name
}

output "iam_role_name" {
  description = "IAM Role attached to EC2"
  value       = module.iam.role_name
}

##############################################
# EC2 Outputs
##############################################

output "launch_template_id" {
  description = "Launch Template ID"
  value       = module.ec2.launch_template_id
}

##############################################
# Load Balancer Outputs
##############################################

output "target_group_arn" {
  description = "Target Group ARN"
  value       = module.alb.target_group_arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS Name"
  value       = module.alb.alb_dns_name
}

##############################################
# Auto Scaling Outputs
##############################################

output "autoscaling_group_name" {
  description = "Auto Scaling Group Name"
  value       = module.autoscaling.autoscaling_group_name
}

##############################################
# Database Outputs
##############################################

output "database_endpoint" {
  description = "MySQL RDS Endpoint"
  value       = module.rds.db_endpoint
}

output "database_port" {
  description = "MySQL RDS Port"
  value       = module.rds.db_port
}