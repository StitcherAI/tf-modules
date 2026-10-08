# -----------------------------------------------------------------------------
# Grants for the StitcherAI reader service principal
#
# Unity Catalog evaluates a view with the privileges of the view *owner* (the
# identity Terraform runs as), not the caller. The reader SP therefore only
# needs USE_CATALOG / USE_SCHEMA / SELECT on the StitcherAI catalog and schema.
#
# Precondition for the deployer identity, NOT granted here:
#   - the system schemas system.billing, system.compute, system.lakeflow and
#     system.access must be enabled on the metastore, and
#   - the deployer must have USE SCHEMA + SELECT on them, since it owns the
#     views that read from them.
# -----------------------------------------------------------------------------
resource "databricks_grant" "stitcherai_catalog_access" {
  provider   = databricks.workspace
  catalog    = local.catalog_name
  principal  = databricks_service_principal.stitcherai_sp.application_id
  privileges = ["USE_CATALOG"]
}

resource "databricks_grant" "stitcherai_schema_access" {
  provider   = databricks.workspace
  schema     = local.schema_fqn
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
