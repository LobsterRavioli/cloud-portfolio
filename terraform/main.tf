provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Basic"
    size = "B1"
  }

  kind = "Linux"
  reserved = true
}

resource "azurerm_app_service" "app" {
  name                = var.app_service_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "DOCKER|toms1/flask-healthcheck-backend:latest"
    always_on        = true
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    DOCKER_REGISTRY_SERVER_URL         = "https://index.docker.io"
    COSMOS_URI = azurerm_cosmosdb_account.cosmos_account.endpoint
    COSMOS_KEY = azurerm_cosmosdb_account.cosmos_account.primary_key
  }
}

resource "azurerm_static_site" "example" {
  name                = "example-static-site"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_tier            = "Free"

  # repository_url, branch, app_location, output_location non sono supportati da questo provider/versione
}


resource "azurerm_cosmosdb_account" "cosmos_account" {
  name                = "cosmos-account99"
  location            = "Italy North"
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "Session"
  }

  geo_location {
    location          = "Italy North"
    failover_priority = 0
  }

  capabilities {
    name = "EnableServerless" # opzionale: puoi rimuoverlo per provisioned throughput
  }


}

resource "azurerm_cosmosdb_sql_database" "cosmos_db" {
  name                = "azure-sql-db"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos_account.name  
}

resource "azurerm_cosmosdb_sql_container" "visite_container" {
  name                  = "visite"
  resource_group_name   = azurerm_resource_group.rg.name
  account_name          = azurerm_cosmosdb_account.cosmos_account.name
  database_name         = azurerm_cosmosdb_sql_database.cosmos_db.name
  partition_key_paths = ["/id"]      

  #throughput            = 400  # puoi omettere questo se usi "EnableServerless"

  indexing_policy {
    indexing_mode = "consistent"
  }
}