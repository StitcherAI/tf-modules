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

output "view_stitcherai_focus_v1_3" {
  value       = "${var.catalog_name}.${databricks_schema.stitcherai_billing_schema.name}.${databricks_sql_table.stitcherai_focus_view.name}"
  description = "The database string route where applications query the unified FOCUS v1.3 cost data."
}

output "view_pipelines_path" {
  value       = "${var.catalog_name}.${databricks_schema.stitcherai_billing_schema.name}.${databricks_sql_table.view_lakeflow_pipelines.name}"
  description = "FQTN for raw Lakeflow pipelines metadata."
}

output "view_clusters_path" {
  value       = "${var.catalog_name}.${databricks_schema.stitcherai_billing_schema.name}.${databricks_sql_table.view_compute_clusters.name}"
  description = "FQTN for raw compute clusters metadata."
}

output "view_warehouses_path" {
  value       = "${var.catalog_name}.${databricks_schema.stitcherai_billing_schema.name}.${databricks_sql_table.view_compute_warehouses.name}"
  description = "FQTN for raw SQL warehouses metadata."
}

output "view_billing_usage_path" {
  value       = "${var.catalog_name}.${databricks_schema.stitcherai_billing_schema.name}.${databricks_sql_table.view_billing_usage.name}"
  description = "FQTN for raw billing and consumption logs."
}

output "view_workspaces_latest_path" {
  value       = "${var.catalog_name}.${databricks_schema.stitcherai_billing_schema.name}.${databricks_sql_table.view_workspaces_latest.name}"
  description = "FQTN for raw workspace identifiers."
}

output "view_billing_list_prices_path" {
  value       = "${var.catalog_name}.${databricks_schema.stitcherai_billing_schema.name}.${databricks_sql_table.view_billing_list_prices.name}"
  description = "FQTN for raw default list pricing data."
}

output "view_billing_account_prices_path" {
  value       = "${var.catalog_name}.${databricks_schema.stitcherai_billing_schema.name}.${databricks_sql_table.view_billing_account_prices.name}"
  description = "FQTN for raw account-specific custom pricing data."
}
