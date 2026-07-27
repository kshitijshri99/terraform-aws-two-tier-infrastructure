variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_web_subnet_ids" {
  type = list(string)
}

variable "launch_template_id" {
  type = string
}

variable "launch_template_version" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}