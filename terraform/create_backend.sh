#!/bin/bash

# Input variables
resourceGroup=$1
storageAccountName=$2
location=$3
containerName="tfstate"

az account import --name "assessment"

# Check if storage account already exists
if az storage account check-name --name $storageAccountName --query 'nameAvailable' | grep -q false; then
    echo "Storage account $storageAccountName already exists. Exiting script."
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
echo "##vso[task.setvariable variable=backend_storage_account]$storageAccountName"
echo "##vso[task.setvariable variable=backend_container]$containerName"
