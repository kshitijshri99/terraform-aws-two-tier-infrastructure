# Bootstrap Infrastructure

This directory provisions the Terraform remote backend.

Resources Created:
- Amazon S3 Bucket (Terraform Remote State)
- Amazon DynamoDB Table (State Locking)

Run this module only once before deploying the main infrastructure.

Commands:

terraform init
terraform plan
terraform apply