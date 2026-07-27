##############################################
# Global Project Variables
##############################################

variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "eu-north-1"

}

variable "project_name" {

  type = string

  default = "terraform-two-tier"

}

variable "environment" {

  type = string

  default = "dev"

}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_web_subnet_cidrs" {
  type = list(string)
}

variable "private_db_subnet_cidrs" {
  type = list(string)
}

# EC2
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

# Auto Scaling
variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  type        = number
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
  type        = number
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "engine_version" {
  type = string
}

variable "health_check_path" {
  description = "ALB health check path"
  type        = string
  default     = "/"
}