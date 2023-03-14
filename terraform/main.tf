terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
   backend "azurerm" {
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = var.backend_key
    resource_group_name  = var.backend_resource_group_name
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "resource1" {
  name     = "old"
  location = "West Europe"
}


resource "azurerm_resource_group" "resource2" {
  name     = "new"
  location = "West Europe"
}


resource "azurerm_resource_group" "resource3" {
  name     = "third"
  location = "West Europe"
}