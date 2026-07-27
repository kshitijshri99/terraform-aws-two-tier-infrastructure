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
# DB Subnet Group
##############################################

resource "aws_db_subnet_group" "main" {

  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-db-subnet-group"
  })

}

##############################################
# MySQL Database
##############################################

resource "aws_db_instance" "mysql" {

  identifier = "${var.project_name}-mysql"

  engine         = "mysql"
  engine_version = var.engine_version

  instance_class    = var.db_instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    var.rds_security_group_id
  ]

  #################################################
  # High Availability
  #################################################

  multi_az = false

  #################################################
  # Security
  #################################################

  publicly_accessible        = false
  storage_encrypted          = true
  auto_minor_version_upgrade = true

  #################################################
  # Backup
  #################################################

  backup_retention_period = 1
  backup_window           = "02:00-03:00"

  #################################################
  # Maintenance
  #################################################

  maintenance_window = "Sun:03:00-Sun:04:00"

  #################################################
  # Monitoring
  #################################################

  monitoring_interval = 0

  #################################################
  # Deletion
  #################################################

  deletion_protection = false
  skip_final_snapshot = true

  #################################################
  # Performance Insights
  #################################################

  performance_insights_enabled = false

  #################################################
  # Tags
  #################################################

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-mysql"
  })

}