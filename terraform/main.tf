terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
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
  admin_enabled       = false

}


# Mysql server
resource "azurerm_mysql_server" "database" {
  name                = "${var.unique_var}-mysqlserver"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
}

# App service plan
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.unique_var}-appserviceplan"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}


#App service
resource "azurerm_app_service" "app_service" {
  name                = "${var.unique_var}-app-service"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

}