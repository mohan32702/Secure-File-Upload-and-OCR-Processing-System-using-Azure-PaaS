terraform {
  backend "azurerm" {
    resource_group_name  = "rg-devops-demo"
    storage_account_name = "azrhrfeastus"
    container_name       = "tfstate"
    key                  = "terraform.tfstatefile"
  }
}