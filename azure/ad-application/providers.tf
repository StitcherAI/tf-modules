terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azuread_group" "az_workload_identity_group" {
  display_name     = "StitcherAI-env-${var.environment_id}"
  security_enabled = true
}
