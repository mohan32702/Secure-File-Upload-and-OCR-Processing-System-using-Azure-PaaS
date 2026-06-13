resource "azurerm_service_plan" "example1" {
  name                = "function-plan-${var.env}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "EP1"
}

resource "azurerm_linux_function_app" "example" {
  name                = "func-${var.env}-upload12345"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  service_plan_id = azurerm_service_plan.example1.id

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  functions_extension_version = "~4"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    AzureWebJobsStorage      = azurerm_storage_account.example.primary_connection_string
    AZURE_STORAGE_CONN_STRING = azurerm_storage_account.example.primary_connection_string
    COGNITIVE_API_KEY        = azurerm_cognitive_account.example.primary_access_key
    COGNITIVE_API_ENDPOINT   = azurerm_cognitive_account.example.endpoint
  }

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }
}