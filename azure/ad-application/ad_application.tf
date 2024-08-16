# NOTE: active directory, resources might be renamed to Microsoft Entra

resource "azuread_application_registration" "az_workload_identity_app" {
  display_name = "StitcherAI-env-${var.environment_id}"
}

resource "azuread_service_principal" "az_workload_identity_sp" {
  client_id                    = azuread_application_registration.az_workload_identity_app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]

  account_enabled   = true
  alternative_names = [var.environment_id]
}