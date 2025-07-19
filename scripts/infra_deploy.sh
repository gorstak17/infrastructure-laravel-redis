#!/bin/bash

set -e
set -o pipefail

AWS_REGION="us-east-1"
TF_DIR="./infrastructure"
TFVARS_FILE="terraform.tfvars"

echo "👉 Setting AWS region: $AWS_REGION"
export AWS_REGION=$AWS_REGION

echo "👉 Moving to Terraform directory: $TF_DIR"
cd "$TF_DIR"

echo "👉 Initializing Terraform..."
terraform init

echo "👉 Validating Terraform configuration..."
terraform validate

echo "👉 Formatting Terraform files..."
terraform fmt

echo "👉 Planning Terraform with tfvars..."
terraform plan -var-file="$TFVARS_FILE"

echo "👉 Applying Terraform with tfvars..."
terraform apply -auto-approve -var-file="$TFVARS_FILE"

echo "✅ Terraform infrastructure provisioned successfully."
