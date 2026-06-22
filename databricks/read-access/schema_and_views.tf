resource "databricks_schema" "stitcherai_billing_schema" {
  provider     = databricks.workspace
  catalog_name = var.catalog_name
  name         = "stitcherai_focus_billing"
  comment      = "StitcherAI custom isolated schema mapping Databricks System tables to FOCUS v1.3 standard."
}

resource "databricks_sql_table" "view_lakeflow_pipelines" {
  provider        = databricks.workspace
  catalog_name    = var.catalog_name
  schema_name     = databricks_schema.stitcherai_billing_schema.name
  name            = "pipelines"
  table_type      = "VIEW"
  warehouse_id    = databricks_sql_endpoint.stitcherai_warehouse.id
  view_definition = "SELECT * FROM system.lakeflow.pipelines"
}

resource "databricks_sql_table" "view_compute_clusters" {
  provider        = databricks.workspace
  catalog_name    = var.catalog_name
  schema_name     = databricks_schema.stitcherai_billing_schema.name
  name            = "clusters"
  table_type      = "VIEW"
  warehouse_id    = databricks_sql_endpoint.stitcherai_warehouse.id
  view_definition = "SELECT * FROM system.compute.clusters"
}

resource "databricks_sql_table" "view_compute_warehouses" {
  provider        = databricks.workspace
  catalog_name    = var.catalog_name
  schema_name     = databricks_schema.stitcherai_billing_schema.name
  name            = "warehouses"
  table_type      = "VIEW"
  warehouse_id    = databricks_sql_endpoint.stitcherai_warehouse.id
  view_definition = "SELECT * FROM system.compute.warehouses"
}

resource "databricks_sql_table" "view_billing_usage" {
  provider        = databricks.workspace
  catalog_name    = var.catalog_name
  schema_name     = databricks_schema.stitcherai_billing_schema.name
  name            = "billing_usage"
  table_type      = "VIEW"
  warehouse_id    = databricks_sql_endpoint.stitcherai_warehouse.id
  view_definition = "SELECT * FROM system.billing.usage"
}

resource "databricks_sql_table" "view_workspaces_latest" {
  provider        = databricks.workspace
  catalog_name    = var.catalog_name
  schema_name     = databricks_schema.stitcherai_billing_schema.name
  name            = "workspaces_latest"
  table_type      = "VIEW"
  warehouse_id    = databricks_sql_endpoint.stitcherai_warehouse.id
  view_definition = "SELECT * FROM system.access.workspaces_latest"
}

resource "databricks_sql_table" "view_billing_list_prices" {
  provider        = databricks.workspace
  catalog_name    = var.catalog_name
  schema_name     = databricks_schema.stitcherai_billing_schema.name
  name            = "billing_list_prices"
  table_type      = "VIEW"
  warehouse_id    = databricks_sql_endpoint.stitcherai_warehouse.id
  view_definition = "SELECT * FROM system.billing.list_prices"
}

resource "databricks_sql_table" "view_billing_account_prices" {
  provider        = databricks.workspace
  catalog_name    = var.catalog_name
  schema_name     = databricks_schema.stitcherai_billing_schema.name
  name            = "billing_account_prices"
  table_type      = "VIEW"
  warehouse_id    = databricks_sql_endpoint.stitcherai_warehouse.id
  view_definition = "SELECT * FROM ${var.account_prices_table_path}"
}

resource "databricks_sql_table" "stitcherai_focus_view" {
  provider     = databricks.workspace
  catalog_name = var.catalog_name
  schema_name  = databricks_schema.stitcherai_billing_schema.name
  name         = "stitcherai_focus_v1_3_usage_view"
  table_type   = "VIEW"
  warehouse_id = databricks_sql_endpoint.stitcherai_warehouse.id

  view_definition = <<SQL
    WITH pipeline_names AS (
      SELECT account_id, workspace_id, pipeline_id, name AS pipeline_name
      FROM ${var.catalog_name}.stitcherai_focus_billing.pipelines
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY account_id, workspace_id, pipeline_id ORDER BY create_time DESC
      ) = 1
    ),
    cluster_names AS (
      SELECT account_id, workspace_id, cluster_id, cluster_name
      FROM ${var.catalog_name}.stitcherai_focus_billing.clusters
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY account_id, workspace_id, cluster_id ORDER BY change_time DESC
      ) = 1
    ),
    warehouse_names AS (
      SELECT account_id, workspace_id, warehouse_id, warehouse_name
      FROM ${var.catalog_name}.stitcherai_focus_billing.warehouses
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY account_id, workspace_id, warehouse_id ORDER BY change_time DESC
      ) = 1
    ),
    list_prices as (
      select coalesce(price_end_time, date_add(current_date, 1)) as coalesced_price_end_time, *
      from ${var.catalog_name}.stitcherai_focus_billing.billing_list_prices
      where currency_code = 'USD'
    ),
    account_prices as (
      select coalesce(price_end_time, date_add(current_date, 1)) as coalesced_price_end_time, *
      from ${var.catalog_name}.stitcherai_focus_billing.billing_account_prices
      where currency_code = 'USD'
    ),
    usage_with_pricing AS (
      SELECT
        u.record_id,
        u.account_id,
        u.workspace_id,
        w.workspace_name,
        u.sku_name,
        u.cloud,
        u.usage_start_time,
        u.usage_end_time,
        u.usage_date,
        u.usage_quantity,
        u.usage_unit,
        u.usage_type,
        u.custom_tags,
        u.usage_metadata,
        u.product_features,
        u.billing_origin_product,
        pip.pipeline_name,
        cl.cluster_name,
        wh.warehouse_name,
        lp.currency_code,
        lp.price_start_time,
        CAST(lp.pricing.default AS DECIMAL(30, 15)) AS list_unit_price,
        CAST(ap.pricing.default AS DECIMAL(30, 15)) AS account_unit_price
      FROM
        ${var.catalog_name}.stitcherai_focus_billing.billing_usage u
          LEFT JOIN list_prices lp
            ON u.sku_name = lp.sku_name
            AND u.usage_unit = lp.usage_unit
            AND u.account_id = lp.account_id
            AND u.usage_end_time between lp.price_start_time and lp.coalesced_price_end_time
          LEFT JOIN account_prices ap
            ON u.sku_name = ap.sku_name
            AND u.usage_unit = ap.usage_unit
            AND u.account_id = ap.account_id
            AND u.usage_end_time between ap.price_start_time and ap.coalesced_price_end_time
          LEFT JOIN ${var.catalog_name}.stitcherai_focus_billing.workspaces_latest w
            ON u.account_id = w.account_id
            AND u.workspace_id = w.workspace_id
          LEFT JOIN pipeline_names pip
            ON u.account_id = pip.account_id
            AND u.workspace_id = pip.workspace_id
            AND u.usage_metadata.dlt_pipeline_id = pip.pipeline_id
          LEFT JOIN cluster_names cl
            ON u.account_id = cl.account_id
            AND u.workspace_id = cl.workspace_id
            AND u.usage_metadata.cluster_id = cl.cluster_id
          LEFT JOIN warehouse_names wh
            ON u.account_id = wh.account_id
            AND u.workspace_id = wh.workspace_id
            AND u.usage_metadata.warehouse_id = wh.warehouse_id
    )
    SELECT
      CAST(NULL AS STRING) AS AvailabilityZone,
      CAST(COALESCE(u.usage_quantity * u.account_unit_price, 0) AS DECIMAL(30, 15)) AS BilledCost,
      u.account_id AS BillingAccountId,
      u.account_id AS BillingAccountName,
      CAST(NULL AS STRING) AS BillingAccountType,
      u.currency_code AS BillingCurrency,
      DATE_TRUNC('MONTH', u.usage_date) + INTERVAL 1 MONTH AS BillingPeriodEnd,
      DATE_TRUNC('MONTH', u.usage_date) AS BillingPeriodStart,
      CAST(NULL AS STRING) AS CapacityReservationId,
      CAST(NULL AS STRING) AS CapacityReservationStatus,
      'Usage' AS ChargeCategory,
      CAST(NULL AS STRING) AS ChargeClass,
      u.sku_name AS ChargeDescription,
      'Usage-Based' AS ChargeFrequency,
      u.usage_end_time AS ChargePeriodEnd,
      u.usage_start_time AS ChargePeriodStart,
      CAST(NULL AS STRING) AS CommitmentDiscountCategory,
      CAST(NULL AS STRING) AS CommitmentDiscountId,
      CAST(NULL AS STRING) AS CommitmentDiscountName,
      CAST(NULL AS DECIMAL(30, 15)) AS CommitmentDiscountQuantity,
      CAST(NULL AS STRING) AS CommitmentDiscountStatus,
      CAST(NULL AS STRING) AS CommitmentDiscountType,
      CAST(NULL AS STRING) AS CommitmentDiscountUnit,
      CAST(u.usage_quantity AS DECIMAL(30, 15)) AS ConsumedQuantity,
      u.usage_unit AS ConsumedUnit,
      CAST(COALESCE(u.usage_quantity * u.account_unit_price, 0) AS DECIMAL(30, 15)) AS ContractedCost,
      CAST(u.account_unit_price AS DECIMAL(30, 15)) AS ContractedUnitPrice,
      CAST(COALESCE(u.usage_quantity * u.account_unit_price, 0) AS DECIMAL(30, 15)) AS EffectiveCost,
      CASE u.cloud
        WHEN 'AWS' THEN 'Amazon Web Services'
        WHEN 'AZURE' THEN 'Microsoft Azure'
        WHEN 'GCP' THEN 'Google Cloud Platform'
        ELSE u.cloud
      END AS HostProviderName,
      CAST(NULL AS STRING) AS InvoiceId,
      'Databricks' AS InvoiceIssuerName,
      CAST(COALESCE(u.usage_quantity * u.list_unit_price, 0) AS DECIMAL(30, 15)) AS ListCost,
      CAST(u.list_unit_price AS DECIMAL(30, 15)) AS ListUnitPrice,
      'Standard' AS PricingCategory,
      u.currency_code AS PricingCurrency
    FROM usage_with_pricing u
SQL

  depends_on = [
    databricks_sql_table.view_lakeflow_pipelines,
    databricks_sql_table.view_compute_clusters,
    databricks_sql_table.view_compute_warehouses,
    databricks_sql_table.view_billing_usage,
    databricks_sql_table.view_workspaces_latest,
    databricks_sql_table.view_billing_list_prices,
    databricks_sql_table.view_billing_account_prices,
  ]
}
