resource "databricks_service_principal" "stitcherai_sp" {
  provider     = databricks.workspace
  display_name = "stitcherai-focus-billing-reader-sp"
}

resource "databricks_service_principal_secret" "stitcherai_sp_secret" {
  provider             = databricks.account
  service_principal_id = databricks_service_principal.stitcherai_sp.id
}

resource "databricks_sql_endpoint" "stitcherai_warehouse" {
  provider                  = databricks.workspace
  name                      = "stitcherai-focus-billing-warehouse"
  cluster_size              = var.sql_warehouse_size
  max_num_clusters          = 1
  auto_stop_mins            = 10
  enable_serverless_compute = true
}
