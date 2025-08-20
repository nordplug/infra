#!/bin/bash
set -e

echo "🚀 Initializing Nordplug Infrastructure"

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform first."
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS CLI is not configured. Please run 'aws configure' first."
    exit 1
fi

echo "✅ Prerequisites check passed"

# Initialize Terraform
echo "📦 Initializing Terraform..."
terraform init

# Validate Terraform configuration
echo "✅ Validating Terraform configuration..."
terraform validate

echo "🎉 Infrastructure initialization complete!"
echo ""
echo "Next steps:"
echo "1. Copy terraform.tfvars.example to terraform.tfvars and configure"
echo "2. Run './scripts/plan.sh' to see what will be created"
echo "3. Run './scripts/apply.sh' to create infrastructure"