variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "bucket_name" {
  type    = string
  default = "kshitij-shrivastava-terraform-state-2026"
}

variable "dynamodb_table" {
  type    = string
  default = "terraform-lock-table"
}