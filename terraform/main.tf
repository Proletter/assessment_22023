terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.48.0"
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

resource "azurerm_resource_group" "resource_group" {
  name     = "assessment_resource_grp"
  location = "East US"
}


#Azure container registry
resource "azurerm_container_registry" "acr" {
  name                = var.container_registry
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  sku                 = "Premium"
  admin_enabled       = true

}


# Kubernetes

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.unique_var}-aks"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  dns_prefix = "${var.unique_var}prefix"

  identity {
    type = "SystemAssigned"
  }

}