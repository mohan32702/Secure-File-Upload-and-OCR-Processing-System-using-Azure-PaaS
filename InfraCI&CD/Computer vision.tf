resource "azurerm_cognitive_account" "example" {
  name                = "cv-${var.env}-12345"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "ComputerVision"
  sku_name            = "S1"
}