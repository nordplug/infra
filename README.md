# Nordplug Infrastructure

This repository contains all AWS infrastructure as code using Terraform for the Nordplug application.

## Structure

```
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/
│   ├── lambda/
│   ├── dynamodb/
│   ├── sns/
│   └── api-gateway/
├── scripts/
└── terraform.tfvars.example
```

## Quick Start

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy (if needed)
terraform destroy
```

## Current AWS Resources

- **Lambda Functions**: 11 functions (Python 3.9 + Node.js 18.x)
- **DynamoDB Tables**: 10 tables with PAY_PER_REQUEST billing
- **SNS Topics**: 4 notification topics
- **API Gateway**: 1 REST API (NordplugAPI)
- **IAM Roles**: Service-specific roles for Lambda functions

## Environment Variables

Copy `terraform.tfvars.example` to `terraform.tfvars` and configure:

```hcl
aws_region = "eu-north-1"
account_id = "714876270401"
environment = "prod"
```