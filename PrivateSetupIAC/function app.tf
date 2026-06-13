resource "azurerm_service_plan" "example1" {
  name                = "azure-functions-example-sp"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "EP1" # Premium plan for Linux Functions
}



resource "azurerm_linux_function_app" "example" {
  name                = "secure-file-upload-functionapp"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  service_plan_id = azurerm_service_plan.example1.id

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  public_network_access_enabled = false

  functions_extension_version = "~4"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"

    AzureWebJobsStorage       = azurerm_storage_account.example.primary_connection_string
    AZURE_STORAGE_CONN_STRING = azurerm_storage_account.example.primary_connection_string

    COGNITIVE_API_KEY      = azurerm_cognitive_account.example.primary_access_key
    COGNITIVE_API_ENDPOINT = azurerm_cognitive_account.example.endpoint
  }

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }
}

data "azurerm_subnet" "function_subnet" {
  name                 = "hybridsubnet-2"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_vnet" {
  app_service_id = azurerm_linux_function_app.example.id
  subnet_id      = data.azurerm_subnet.function_subnet.id
}

resource "azurerm_private_endpoint" "function_pe" {
  name                = "function-pe"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "function-private-connection"
    private_connection_resource_id = azurerm_linux_function_app.example.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "function-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.webapp.id]
  }
}