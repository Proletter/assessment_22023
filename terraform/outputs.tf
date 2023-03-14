output "database_url" {
  value = azurerm_mysql_server.database.fqdn
}