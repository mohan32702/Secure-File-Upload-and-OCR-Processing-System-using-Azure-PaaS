resource "azurerm_cognitive_account" "example" {
  name                = "example-account"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "ComputerVision"

  sku_name = "S1"
custom_subdomain_name = "securefileuploadcv"
  public_network_access_enabled = false


}
resource "azurerm_private_endpoint" "computer_vision" {
  name                = "cv-pe"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "cv-connection"
    private_connection_resource_id = azurerm_cognitive_account.example.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "cv-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.cognitive.id]
  }
}


output "ComputerVisionKey" {
  value     = azurerm_cognitive_account.example.primary_access_key
  sensitive = true
}

output "ComputerVisionEndpoint" {
  value     = azurerm_cognitive_account.example.endpoint
  sensitive = true
}