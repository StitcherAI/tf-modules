output "stitcherai_client_id" {
  value       = databricks_service_principal.stitcherai_sp.application_id
  description = "OAuth Application Identity client key for StitcherAI integrations."
}

output "stitcherai_client_secret" {
  value       = databricks_service_principal_secret.stitcherai_sp_secret.secret
  sensitive   = true
  description = "OAuth Application Identity security token credential. Keep this secure."
}

output "stitcherai_warehouse_id" {
  value       = databricks_sql_endpoint.stitcherai_warehouse.id
  description = "Target Compute Warehouse configuration string identifier for API payloads."
}
