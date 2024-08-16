output "stitcher_ai_app_client_id" {
  value = azuread_application_registration.az_workload_identity_app.id

  description = "Value of the client id of the StitcherAI application, this needs to be configured while creating data sources"
}

output "stitcher_ai_service_principal_id" {
  value = azuread_service_principal.az_workload_identity_sp.id

  description = "Value of the service principal id of the StitcherAI application, this needs to be configured while creating data sources"
}
