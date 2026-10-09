# Target configuration settings for StitcherAI
#
# catalog_name must be an EXISTING catalog you own; this module creates the
# stitcherai_focus_billing schema and views inside it. It cannot be the
# read-only `system` catalog (the views read from system.* but cannot live
# there). Typical values: "main" on classic workspaces, or the workspace
# catalog (named after your workspace) on serverless / Default Storage
# workspaces. You may also create a dedicated catalog once in Catalog Explorer
# and name it here.
catalog_name       = "workspace"
sql_warehouse_size = "Small"

# Default fallback is system table standard.
# For Account Prices Preview (AWS/GCP), update this path string to "system.billing.account_prices"
account_prices_table_path = "system.billing.list_prices"

# Databricks CLI profiles Terraform authenticates with. Create them before
# running terraform:
#   databricks auth login --host https://dbc-xxxx.cloud.databricks.com --profile stitcherai-workspace
#   databricks auth login --host https://accounts.cloud.databricks.com --account-id <ACCOUNT-ID> --profile stitcherai-account
workspace_profile = "stitcherai-workspace"
account_profile   = "stitcherai-account"
