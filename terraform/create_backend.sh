#!/bin/bash

# Input variables
resourceGroup=$1
storageAccountName=$2
location=$3
containerName="tfstate"
password=$4
appid="f047e138-981b-47b5-997f-669b8310f38d"
tenantid="c579f8a6-171d-4be4-ba33-68b16a8ae922"

az login --service-principal --tenant $tenantid --username $appid --password $password

# Check if pipeline variables already exist
if [ -n "$backend_resource_group" ] && [ -n "$backend_storage_account" ] && [ -n "$backend_container" ]; then
    echo "Terraform backend already configured. Skipping backend creation."
    exit 0
fi

# Check if storage account already exists
if az storage account check-name --name $storageAccountName --query 'nameAvailable' | grep -q false; then
    echo "Storage account $storageAccountName already exists. Skipping backend creation."
    echo "If you are running this pipeline for the first time, please provide a unique storage account name."
    echo "If you are running this pipeline after your first time, please ignore. Your terraform backend has already been configured."
    
    # Set pipeline variables for backend configuration
    echo "##vso[task.setvariable variable=backend_resource_group]$(az storage account show --name $storageAccountName --query 'resourceGroup' -o tsv)"
    echo "##vso[task.setvariable variable=backend_storage_account]$storageAccountName"
    echo "##vso[task.setvariable variable=backend_container]$containerName"
    
    exit 0
fi

# Create resource group if it doesn't exist
az group create --name $resourceGroup --location $location

# Create storage account
az storage account create --name $storageAccountName --resource-group $resourceGroup --sku Standard_LRS --encryption-services blob --location $location

# Create container for Terraform state file
az storage container create --account-name $storageAccountName --account-key $(az storage account keys list --resource-group $resourceGroup --account-name $storageAccountName --query '[0].value' -o tsv) --name $containerName

# Output Terraform backend configuration
cat << EOF > backend-config.txt
backend "azurerm" {
  resource_group_name  = "$resourceGroup"
  storage_account_name = "$storageAccountName"
  container_name       = "$containerName"
  key                  = "terraform.tfstate"
}
EOF

# Set pipeline variables for backend configuration
echo "##vso[task.setvariable variable=backend_resource_group]$resourceGroup"
echo "##vso[task.setvariable variable=backend_storage_account]$storageAccountName "
echo "##vso[task.setvariable variable=backend_container]$containerName"
