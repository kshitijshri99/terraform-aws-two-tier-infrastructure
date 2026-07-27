##############################################
# Remote Backend Configuration
##############################################

terraform {
  backend "s3" {
    bucket         = "kshitij-shrivastava-terraform-state-2026"
    key            = "two-tier/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}