#!/bin/bash

# Define the name of the resource group to delete
rg_name="assessment_resource_grp"

# Login to Azure if not already logged in
if ! az account show > /dev/null; then
  az login
fi

# Set the default subscription
az account set --subscription <subscription-id>

# Delete all resources in the resource group
az group delete --name $rg_name --yes --no-wait

# Delete the resource group itself
az group delete --name $rg_name --yes --no-wait
