resource "azurerm_resource_group" "example" {
  name     = "azr-hrf"
  location = "Canada Central"
}

resource "azurerm_storage_account" "example" {
  name                          = "securefileuploadtest"
  resource_group_name           = azurerm_resource_group.example.name
  location                      = azurerm_resource_group.example.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  
  tags = {
    environment = "staging"
  }

}
data "azurerm_subnet" "pe_subnet" {
  name                 = "hybridsubnet-1"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
}
resource "azurerm_private_endpoint" "storage_blob" {
  name                = "storage-blob-pe"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "storage-blob-connection"
    private_connection_resource_id = azurerm_storage_account.example.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
}


output "connection_string" {
  value     = azurerm_storage_account.example.primary_connection_string
  sensitive = true
}

resource "azurerm_storage_container" "example" {
  name                  = "uploads"
  storage_account_id    = azurerm_storage_account.example.id
  container_access_type = "private"
}


resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "B1"
}


resource "azurerm_linux_web_app" "example" {
  name                          = "secure-file-upload-webapp"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  service_plan_id               = azurerm_service_plan.example.id
  public_network_access_enabled = false
  site_config {
    application_stack {
      python_version = "3.10"
    }

  }
  app_settings = { "BLOB_CONNECTION_STRING" = azurerm_storage_account.example.primary_connection_string }
}
data "azurerm_subnet" "webapp_subnet" {
  name                 = "hybridsubnet-3"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
}

resource "azurerm_app_service_virtual_network_swift_connection" "webapp_vnet" {
  app_service_id = azurerm_linux_web_app.example.id
  subnet_id      = data.azurerm_subnet.webapp_subnet.id
}

resource "azurerm_private_endpoint" "webapp_pe" {
  name                = "webapp-pe"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "webapp-connection"
    private_connection_resource_id = azurerm_linux_web_app.example.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "webapp-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.webapp.id]
  }
}

