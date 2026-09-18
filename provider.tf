provider "azurerm" {
  features {}

  tenant_id       = "ff93a2fa-ff2c-40fd-b26a-36c50ea51890"
  subscription_id = "c1210efc-75aa-4ffb-891a-e1c38f9f32ff"

  # No client_id/client_secret needed — provider will also use the az cli session
  use_cli = true
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.6.0"   # pin to whatever's current when you init
    }
  }
  required_version = ">= 1.5.0"
}