#!/bin/bash
set -e

echo "💥 Destroying Nordplug Infrastructure"

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo "❌ terraform.tfvars not found!"
    exit 1
fi

# Strong warning
echo "⚠️  WARNING: This will PERMANENTLY DELETE all AWS infrastructure!"
echo "This action cannot be undone!"
echo ""
read -p "Type 'DELETE' to confirm destruction: " confirm

if [ "$confirm" != "DELETE" ]; then
    echo "❌ Operation cancelled."
    exit 1
fi

# Final confirmation
read -p "Are you absolutely sure? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled."
    exit 1
fi

# Run terraform destroy
echo "💥 Destroying infrastructure..."
terraform destroy -var-file=terraform.tfvars

echo ""
echo "💀 Infrastructure destroyed successfully!"