resource "databricks_grant" "stitcherai_catalog_access" {
  provider   = databricks.workspace
  catalog    = var.catalog_name
  principal  = databricks_service_principal.stitcherai_sp.application_id
  privileges = ["USE_CATALOG"]
}

resource "databricks_grant" "stitcherai_schema_access" {
  provider   = databricks.workspace
  schema     = "${var.catalog_name}.${databricks_schema.stitcherai_billing_schema.name}"
  principal  = databricks_service_principal.stitcherai_sp.application_id
  privileges = ["USE_SCHEMA", "SELECT"]
}

resource "databricks_permissions" "stitcherai_warehouse_permissions" {
  provider        = databricks.workspace
  sql_endpoint_id = databricks_sql_endpoint.stitcherai_warehouse.id

  access_control {
    service_principal_name = databricks_service_principal.stitcherai_sp.application_id
    permission_level       = "CAN_USE"
  }
}
