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
# Target Group
##############################################

resource "aws_lb_target_group" "web" {

  name             = "${var.project_name}-tg"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "instance"

  vpc_id = var.vpc_id

  deregistration_delay = 30

  health_check {

    enabled             = true
    interval            = 30
    path                = var.health_check_path
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"

  }

  tags = merge(local.common_tags, {

    Name = "${var.project_name}-tg"

  })

}

##############################################
# Application Load Balancer
##############################################

resource "aws_lb" "web" {

  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.public_subnet_ids

  enable_http2               = true
  enable_deletion_protection = false
  idle_timeout               = 60

  tags = merge(local.common_tags, {

    Name = "${var.project_name}-alb"

  })

  lifecycle {

    create_before_destroy = true

  }

}

##############################################
# HTTP Listener
##############################################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.web.arn

  port     = 80
  protocol = "HTTP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn

  }

}