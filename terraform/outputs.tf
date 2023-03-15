output "database_url" {
  value = azurerm_mysql_server.database.fqdn
}


output "acr_url" {
  value = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}