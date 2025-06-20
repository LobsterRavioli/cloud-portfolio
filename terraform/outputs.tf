output "app_url" {
  value = azurerm_app_service.app.default_site_hostname
  description = "URL dell'app deployata"
}

output "cosmos_endpoint" {
  value = azurerm_cosmosdb_account.cosmos_account.endpoint
}

output "cosmos_primary_key" {
  value     = azurerm_cosmosdb_account.cosmos_account.primary_key
  sensitive = true
}