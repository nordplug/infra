terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = "714876270401"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "nordplug"
}

# Common tags
locals {
  common_tags = {
    Environment   = var.environment
    Application   = var.app_name
    ManagedBy    = "terraform"
    Repository   = "infrastructure"
  }
}

# Modules
module "dynamodb" {
  source = "./modules/dynamodb"
  
  environment = var.environment
  app_name    = var.app_name
  common_tags = local.common_tags
}

module "sns" {
  source = "./modules/sns"
  
  environment = var.environment
  app_name    = var.app_name
  account_id  = var.account_id
  aws_region  = var.aws_region
  common_tags = local.common_tags
}

module "lambda" {
  source = "./modules/lambda"
  
  environment = var.environment
  app_name    = var.app_name
  account_id  = var.account_id
  aws_region  = var.aws_region
  common_tags = local.common_tags
  
  # Dependencies
  sns_topics = module.sns.topic_arns
  dynamodb_tables = module.dynamodb.table_names
}

module "api_gateway" {
  source = "./modules/api-gateway"
  
  environment = var.environment
  app_name    = var.app_name
  common_tags = local.common_tags
  
  # Dependencies
  lambda_functions = module.lambda.function_arns
}