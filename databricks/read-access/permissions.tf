# -----------------------------------------------------------------------------
# Grants for the StitcherAI reader service principal
#
# The StitcherAI extractor queries the system tables directly, so the reader SP
# needs USE_CATALOG on `system` and USE_SCHEMA + SELECT on each system schema
# it reads. It also gets read access to the StitcherAI schema and its views.
#
# Preconditions for the deployer identity, NOT granted here:
#   - the system schemas system.billing, system.compute, system.lakeflow and
#     system.access must be enabled on the metastore,
#   - the deployer must be both an account admin and a metastore admin. Only
#     a metastore admin can grant access to the system schemas, and a
#     metastore that Databricks created automatically has no metastore admin
#     until an account admin assigns one in the account console, and
#   - the deployer must not be the identity configured in StitcherAI, or the
#     extractor reads with admin rights and these grants go untested.
# -----------------------------------------------------------------------------
locals {
  system_schemas = toset([
    "system.billing",
    "system.compute",
    "system.access",
    "system.lakeflow",
  ])
}

resource "databricks_grant" "stitcherai_system_catalog_access" {
  provider   = databricks.workspace
  catalog    = "system"
  principal  = databricks_service_principal.stitcherai_sp.application_id
  privileges = ["USE_CATALOG"]
}

resource "databricks_grant" "stitcherai_system_schema_access" {
  for_each   = local.system_schemas
  provider   = databricks.workspace
  schema     = each.value
  principal  = databricks_service_principal.stitcherai_sp.application_id
  privileges = ["USE_SCHEMA", "SELECT"]
}

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
