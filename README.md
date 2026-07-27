# AWS Two-Tier Infrastructure using Terraform

<p align="center">

![Terraform](https://img.shields.io/badge/Terraform-v1.12+-623CE4?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazonaws)
![IaC](https://img.shields.io/badge/Infrastructure_as_Code-Terraform-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

</p>

## 📖 Overview

This project provisions a production-inspired **AWS Two-Tier Architecture** using **Terraform** and follows Infrastructure as Code (IaC) best practices. The infrastructure is deployed across two Availability Zones and includes secure networking, an Application Load Balancer, Auto Scaling Group, EC2 instances, Amazon RDS MySQL, IAM, and a remote Terraform backend using Amazon S3 and DynamoDB.

---

# 🏗️ Architecture

<p align="center">
<img src="images/architecture-diagram.png" width="100%">
</p>

## ✨ Features

- Modular Terraform project
- Custom VPC (10.0.0.0/16)
- Public & Private Subnets
- Internet Gateway & NAT Gateway
- Application Load Balancer
- Launch Template
- Auto Scaling Group
- Amazon RDS MySQL
- IAM Role & Instance Profile
- S3 Remote Backend
- DynamoDB State Locking
- Separate Bootstrap module for provisioning Terraform Remote Backend (Amazon S3 + DynamoDB)

## 🌐 Network Layout

| Resource | CIDR |
|----------|------|
| VPC | 10.0.0.0/16 |
| Public A | 10.0.1.0/24 |
| Public B | 10.0.2.0/24 |
| Private Web A | 10.0.11.0/24 |
| Private Web B | 10.0.12.0/24 |
| Private DB A | 10.0.21.0/24 |
| Private DB B | 10.0.22.0/24 |

## 🚀 Deployment

The infrastructure deployment follows two stages:

### Stage 1 – Bootstrap Backend

Navigate to the `bootstrap/` directory and create the Terraform backend resources.

```bash
cd bootstrap
terraform init
terraform apply
```

This provisions:

- Amazon S3 Bucket (Terraform Remote State)
- Amazon DynamoDB Table (Terraform State Locking)

### Stage 2 – Deploy Main Infrastructure

Return to the project root and deploy the application infrastructure.

```bash
cd ..
terraform init
terraform apply
```

This provisions:

- VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateways
- Security Groups
- IAM Role
- EC2 Launch Template
- Auto Scaling Group
- Application Load Balancer
- Amazon RDS MySQL


## 📊 Terraform Apply

![](images/terraform-apply.png)

## 📈 Terraform Outputs

![](images/terraform-output.png)

## 🌍 Application Output

![](images/final-landing-page.png)

# AWS Console Resources

## VPC
![](images/vpc.png)

## Subnets
![](images/subnets.png)

## Route Tables
![](images/route-tables.png)

## Internet Gateway
![](images/internet-gateway.png)

## NAT Gateway
![](images/nat-gateway.png)

## Security Groups
![](images/security-groups.png)

## Launch Template
![](images/launch-templates.png)

## Auto Scaling Group
![](images/auto-scaling-groups.png)

## Application Load Balancer
![](images/alb.png)

## Target Group
![](images/target-groups.png)

## EC2 Instances
![](images/instances.png)

## Amazon RDS
![](images/rds-instance.png)

## DB Subnet Group
![](images/db-subnet-group.png)

## IAM Roles
![](images/iam-roles.png)

## Bootstrap Module

The `bootstrap/` directory contains a separate Terraform configuration used to provision the remote backend infrastructure required by the main project.

It creates:

- Amazon S3 Bucket for storing the Terraform remote state
- Amazon DynamoDB Table for Terraform state locking

This bootstrap configuration is executed only once before deploying the main infrastructure.

After the backend resources are created, the main Terraform configuration uses them for remote state management.

## S3 Remote Backend
![](images/s3-bucket.png)

## DynamoDB State Lock
![](images/dynamodb-lock-file.png)

## 🔒 Security

- IAM Roles instead of hardcoded credentials
- Private subnets for application and database tiers
- Security Groups implementing least privilege
- Remote Terraform state with state locking

## 📚 Skills Demonstrated

- Terraform Modules
- AWS Networking
- EC2 & Auto Scaling
- Application Load Balancer
- Amazon RDS
- IAM
- Remote Terraform Backend
- Infrastructure as Code
- Troubleshooting AWS deployments

## Cost Notice

This project provisions billable AWS resources.

Run

```bash
terraform destroy
```

after testing to avoid unnecessary AWS charges.

## 🚀 Future Enhancements

- HTTPS with ACM
- Route 53
- CloudWatch Monitoring
- Jenkins CI/CD
- Dockerized Spring Boot Deployment
- GitHub Actions

## 👨‍💻 Author

**Kshitij Shrivastava**

- GitHub: https://github.com/kshitijshri99
- LinkedIn: https://linkedin.com/in/kshitij-shrivastava-17551b172/

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
