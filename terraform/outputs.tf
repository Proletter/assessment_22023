output "database_url" {
  value = azurerm_mysql_server.database.fqdn
}


output "acr_url" {
  value = azurerm_container_registry.acr.login_server
}