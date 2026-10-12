# -----------------------------------------------------------------------------
# Grants for the StitcherAI reader service principal
#
# The StitcherAI extractor queries the system tables directly, so the reader SP
# needs USE_CATALOG on `system`, USE_SCHEMA on each system schema it reads, and
# SELECT on the tables in them.
#
# SELECT is granted on the whole system.billing, system.compute and
# system.lakeflow schemas. A schema grant covers tables Databricks adds later,
# such as system.billing.account_prices, so StitcherAI can read new cost and
# resource tables without the customer applying this module again. Those
# schemas hold only billing data and compute and job metadata.
#
# system.access also holds the audit log, lineage, and Genie Code messages,
# so the SP gets SELECT on system.access.workspaces_latest only.
#
# Preconditions for the deployer identity, NOT granted here:
#   - the system schemas system.billing, system.compute, system.lakeflow and
#     system.access must be enabled on the metastore,
#   - the deployer must be an account admin, a metastore admin, and a
#     workspace admin of the target workspace. Only a metastore admin can
#     grant access to the system schemas, and a metastore that Databricks
#     created automatically has no metastore admin until an account admin
#     assigns one in the account console. Only a workspace admin can create
#     the service principal and the SQL warehouse. Account admin does not
#     include workspace admin; an account admin assigns it in the account
#     console under the workspace's permissions, and
#   - the deployer must not be the identity configured in StitcherAI, or the
#     extractor reads with admin rights and these grants go untested.
# -----------------------------------------------------------------------------
locals {
  system_schemas_full_read = toset([
    "system.billing",
    "system.compute",
    "system.lakeflow",
  ])

  system_access_tables = toset([
    "system.access.workspaces_latest",
  ])
}

resource "databricks_grant" "stitcherai_system_catalog_access" {
  provider   = databricks.workspace
  catalog    = "system"
  principal  = databricks_service_principal.stitcherai_sp.application_id
  privileges = ["USE_CATALOG"]
}

resource "databricks_grant" "stitcherai_system_schema_access" {
  for_each   = local.system_schemas_full_read
  provider   = databricks.workspace
  schema     = each.value
  principal  = databricks_service_principal.stitcherai_sp.application_id
  privileges = ["USE_SCHEMA", "SELECT"]
}

resource "databricks_grant" "stitcherai_system_access_schema_usage" {
  provider   = databricks.workspace
  schema     = "system.access"
  principal  = databricks_service_principal.stitcherai_sp.application_id
  privileges = ["USE_SCHEMA"]
}

resource "databricks_grant" "stitcherai_system_access_table_select" {
  for_each   = local.system_access_tables
  provider   = databricks.workspace
  table      = each.value
  principal  = databricks_service_principal.stitcherai_sp.application_id
  privileges = ["SELECT"]
}

resource "databricks_permissions" "stitcherai_warehouse_permissions" {
  provider        = databricks.workspace
  sql_endpoint_id = databricks_sql_endpoint.stitcherai_warehouse.id

  access_control {
    service_principal_name = databricks_service_principal.stitcherai_sp.application_id
    permission_level       = "CAN_USE"
  }
}
