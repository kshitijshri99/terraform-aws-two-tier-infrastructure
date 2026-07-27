##############################################
# Common Tags
##############################################

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

##############################################
# Auto Scaling Group
##############################################

resource "aws_autoscaling_group" "web" {

  name = "${var.project_name}-asg"

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  vpc_zone_identifier = var.private_web_subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {

    id      = var.launch_template_id
    version = var.launch_template_version

  }

  ####################################################
  # Rolling Instance Refresh
  ####################################################

  instance_refresh {

    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }


  }

  ####################################################
  # Tags
  ####################################################

  tag {

    key                 = "Name"
    value               = "${var.project_name}-web"
    propagate_at_launch = true

  }

  tag {

    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true

  }

  tag {

    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true

  }

  tag {

    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true

  }

  ####################################################
  # Lifecycle
  ####################################################

  lifecycle {

    create_before_destroy = true

  }

}