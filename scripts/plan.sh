#!/bin/bash
set -e

echo "📋 Planning Nordplug Infrastructure Changes"

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo "❌ terraform.tfvars not found!"
    echo "Please copy terraform.tfvars.example to terraform.tfvars and configure it."
    exit 1
fi

# Run terraform plan
echo "🔍 Analyzing infrastructure changes..."
terraform plan -var-file=terraform.tfvars

echo ""
echo "💡 Review the plan above carefully before applying changes!"
echo "Run './scripts/apply.sh' to apply these changes."