output "stitcher_ai_app_client_id" {
  value = azuread_application_registration.az_workload_identity_app.client_id

  description = "Value of the client id of the StitcherAI application, this needs to be configured while creating data sources"
}

output "azure_tenant_id" {
  value = data.azuread_client_config.current.tenant_id

  description = "Value of the tenant id of the Azure AD tenant, this needs to be configured while creating data sources"
}

output "azure_principal_id" {
  value = azuread_service_principal.az_workload_identity_sp.object_id

  description = "Value of the principal id of the Azure AD service principal, this needs to be configured while creating data sources"
}
