locals {

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

}

##############################################
# Application Load Balancer Security Group
##############################################


resource "aws_security_group" "alb" {

  name = "${var.project_name}-alb-sg"

  description = "ALB Security Group"

  vpc_id = var.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  ingress {

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-alb-sg"
  })

}

##############################################
# EC2 Security Group
##############################################

resource "aws_security_group" "ec2" {

  name = "${var.project_name}-ec2-sg"

  description = "EC2 Security Group"

  vpc_id = var.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-sg"
  })

}

##############################################
# Amazon RDS Security Group
##############################################


resource "aws_security_group" "rds" {

  name = "${var.project_name}-rds-sg"

  description = "RDS Security Group"

  vpc_id = var.vpc_id

  ingress {

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.ec2.id
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-rds-sg"
  })

}