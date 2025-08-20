variable "environment" {
  description = "Environment name"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "sns_topics" {
  description = "SNS topic ARNs"
  type        = map(string)
}

variable "dynamodb_tables" {
  description = "DynamoDB table names"
  type        = map(string)
}