resource "azurerm_resource_group" "example" {
  name     = "azr-hrf-${var.env}"
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = "securefile${var.env}12345"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.env
  }
}

resource "azurerm_service_plan" "example" {
  name                = "webapp-plan-${var.env}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "example" {
  name                = "web-${var.env}-upload12345"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    BLOB_CONNECTION_STRING = azurerm_storage_account.example.primary_connection_string
  }
}