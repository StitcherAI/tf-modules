# Target configuration settings for StitcherAI
catalog_name       = "main"
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
