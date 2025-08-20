#!/bin/bash
set -e

echo "🚀 Applying Nordplug Infrastructure Changes"

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo "❌ terraform.tfvars not found!"
    echo "Please copy terraform.tfvars.example to terraform.tfvars and configure it."
    exit 1
fi

# Confirm with user
echo "⚠️  This will modify AWS infrastructure!"
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled."
    exit 1
fi

# Run terraform apply
echo "🔨 Applying infrastructure changes..."
terraform apply -var-file=terraform.tfvars

echo ""
echo "🎉 Infrastructure changes applied successfully!"
echo "Check AWS Console to verify resources were created correctly."