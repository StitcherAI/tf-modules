data "azuread_client_config" "current" {}

resource "azuread_application_federated_identity_credential" "az_workload_identity_credential" {
  application_id = azuread_application_registration.az_workload_identity_app.id
  display_name   = "StitcherAI-env-${var.environment_id}"
  issuer         = "https://accounts.google.com"
  subject        = var.stitcher_ai_sa_id
  audiences      = ["api://AzureADTokenExchange"]
  description    = "This is meant for workloads for environment ${var.environment_id}"
}
